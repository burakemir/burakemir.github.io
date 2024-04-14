# Persistence

An in-memory database is nice, but persistent storage is important for two use cases:

- in order to make updates and keep them
- in order to deal with larger volumes of data

These can be different strategies for these.

## A model for updates

Let's start with making updates.

- if the size of that data still comfortably fits in memory, then updates can be made in memory and the data saved.
- write-ahead log: if writing everything is slow, update operations can be logged ahead-of-time before affecting db state,
and regular checkpointing applying the updates on disk.

This is all work, but it is predictable work. Instead of adding these to Mangle,
it makes a lot more sense to connect Mangle to an existing LSM-based DB like RocksDB or Cloud Spanner.

## Large Volumes

Instead of serving from memory, we can read from persistent storage for every query. This is what most databases do.
If latency does not play a role, then this persistent storage could be files from block storage.

Again this is mostly integration work. Connecting Mangle to these systems seems o come with many
particular things that distract from the goal of having a simple to understand spec and implementation.
