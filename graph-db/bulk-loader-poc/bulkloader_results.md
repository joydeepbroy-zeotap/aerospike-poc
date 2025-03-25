# Performance Metrics for Bulk Load with Maximum Degree of 140

| Metric                                    | Value             |
|-------------------------------------------|-------------------|
| **Graph Characteristics**                 |                   |
| Max Degree of Node                        | 140               |
| Number of Vertices                        | 542 million       |
| Number of Edges                           | 514 million       |
|                                           |                   |
| **Time Taken for Writes**                 |                   |
| Vertex Writes                             | 1.1 hours         |
| Edge Writes                               | 6.2 hours         |
|                                           |                   |
| **Writes per Second**                     |                   |
| Vertex                                    | 140k records/sec |
| Edge                                      | 20k records/sec  |
|                                           |                   |
| **Read Latency during Vertex Writes**     |                   |
| p95                                       | 1 ms              |
| p99                                       | 1 ms              |
| p99.9                                     | 1 ms              |
|                                           |                   |
| **Read Latency during Edge Writes**       |                   |
| p95                                       | 2 ms              |
| p99                                       | 3 ms              |
| p99.9                                     | 3 ms              |
|                                           |                   |
| **Write Latency during Vertex Writes**    |                   |
| p95                                       | 17 ms             |
| p99                                       | 37 ms             |
| p99.9                                     | 159 ms            |
|                                           |                   |
| **Write Latency during Edge Writes**      |                   |
| p95                                       | 18 ms             |
| p99                                       | 38 ms             |
| p99.9                                     | 226 ms            |
