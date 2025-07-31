# Netdata Streaming Routing

## What is Streaming Routing?

Streaming routing determines how Netdata child nodes connect to parent nodes in a distributed monitoring setup. When multiple parents are available, the routing algorithm automatically selects the best destination and handles failover.

> **Note**: This feature requires configuring streaming in `netdata.conf`. See [Streaming Configuration](https://learn.netdata.cloud/docs/streaming) for setup instructions.

## How Parent Selection Works

When a child node starts or loses connection, it selects a parent using this priority:

1. **Check data completeness** - Prefer parents that already have this node's historical data
2. **Load balance** - Randomly choose among equally suitable parents
3. **Failover** - If connection fails, try the next parent in the list

```
Child Node
    │
    ├─→ Parent A (has historical data) ✓ Selected
    ├─→ Parent B (has historical data)
    └─→ Parent C (no historical data)
```

### Configuration Example

In your child node's `stream.conf`:
```ini
[stream]
    enabled = yes
    destination = parent-a:19999 parent-b:19999 parent-c:19999
    api key = YOUR_API_KEY
```

## Multi-Tier Architecture

In larger deployments, you can create multiple tiers:

```
Child Nodes ──→ Parent Proxies ──→ Ultimate Parents
(collect data)   (forward data)     (store & analyze)
```

This setup distributes the workload:
- **Child nodes**: Collect metrics
- **Parent proxies**: Forward data without heavy processing
- **Ultimate parents**: Store data and run analytics

## Query Routing

Netdata Cloud optimizes query performance by routing requests intelligently:

- **Historical queries** → Sent to the furthest parent (better resources)
- **Live queries** → Sent to the closest node (lower latency)

## Machine Learning Workload

The ML workload distribution depends on your configuration:

| Child ML Setting | Impact |
|-----------------|---------|
| Disabled | Parent must train models from scratch (high CPU usage) |
| Enabled | Child trains models locally and sends results (lower parent CPU) |

## Key Behaviors

### Network vs. Data Priority

Unlike traditional networking, Netdata prioritizes **data integrity** over network efficiency:

- May connect to geographically distant parents if they have better data
- Ensures no metrics are lost during failures
- Automatically rebalances load after recovery

### Failover Example

```
Normal operation:
Child → Parent A (primary)

During Parent A outage:
Child → Parent B (failover)

After recovery:
Child may stay with Parent B if it now has complete data
```

### Connection Behavior

- **Reconnection interval**: 1 second (configurable via `reconnect delay seconds`)
- **Connection timeout**: 60 seconds default
- **Persistent connections**: Child maintains connection until failure
- **No automatic rebalancing**: Child won't switch parents unless current connection fails

## Best Practices

1. **Size parent nodes appropriately** - Consider ML processing requirements
   - Without child ML: Parent needs ~25% more CPU
   - With child ML: Minimal parent CPU increase

2. **Design for regional failures** - Have parents in different locations
3. **Enable ML on child nodes** - Reduces parent CPU usage
4. **Monitor failover patterns** - Identify network reliability issues

## Troubleshooting

### Common Issues

| Symptom | Likely Cause | Solution |
|---------|--------------|----------|
| Child connects to distant parent | Local parent has incomplete data | Wait for data sync or manually clear remote parent's data |
| High parent CPU usage | ML disabled on children | Enable ML on child nodes |
| Frequent failovers | Network instability | Check connectivity between nodes |
| Child won't reconnect | All parents down or API key mismatch | Verify parent availability and API keys |

### Useful Commands

```bash
# Check streaming status on child
netdatacli streaming status

# View streaming logs
grep STREAM /var/log/netdata/error.log

# Test parent connectivity
nc -zv parent-hostname 19999
```

## Summary

Netdata streaming routing automatically:
- Selects the best parent based on data completeness
- Distributes load across available parents
- Handles failover without losing data
- Routes queries for optimal performance

The system prioritizes reliability and data integrity over network optimization, ensuring your monitoring continues working even during complex failure scenarios.
