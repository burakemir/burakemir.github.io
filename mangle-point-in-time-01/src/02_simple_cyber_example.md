# Simple Cyber Example

Here is an example from the cybersecurity domain.

- Queries over streams of events (observations e.g. logs, "facts")

	- on host H, event A happened at time T1 and then event B happened at time T2
  - Correlation, temporal reasoning not nice with SQL (or any language, actually). 

- This is how it might look in a datalog-like language:

```
# suppose T1, T2 are timestamps in seconds since epoch UTC

first_A_then_B(Host, T1, T2) :- 
  eventA(Host, T1),
  eventB(Host, T2),
  :happens_before_within(T1, T2, 10 * 60).

```
- advantages of "Datalog-like" language:
  - modularity/compositionality: can define `eventA` and `eventB` predicates elsewhere
  - readable predicate names `:happens_before_within`

- however: can it be evaluated efficiently?
  - classic DB query planning / optimization for the join
  - distributed: instead of single-machine efficiency, how to shard/route and make embarrasingly parallel
  - incrementality instead of periodic execution

- There are lots of takes on "query language for event processing" ... there is a whole industry
  - Google Chronicle Security [Yara-L 2.0](https://cloud.google.com/chronicle/docs/detection/yara-l-2-0-overview)
  - ElasticSearch [Event Query Language](https://www.elastic.co/guide/en/elasticsearch/reference/current/eql-ex-threat-detection.html)
  - Microsoft Sentinel [Kusto Query Language](https://learn.microsoft.com/en-us/azure/sentinel/kusto-overview)
  - Splunk [Search Processing Language](https://docs.splunk.com/Splexicon:SPL)
  - [Sigma](https://github.com/SigmaHQ/sigma) an attempt at a standard

- Readability, metadata ("what does this detect?"), discoverability are all issues, and we all depend on interoperability being improved here (e.g. hospital ransomware attacks and such)

## Time and Again

While a lot of business data fits in memory now, the volume can change if we preserve full history / time-series (e.g. system logs, observability)

There is in general no one-size-fits-all way.

(This was a subtle reference to Stonebraker and Cetintemel's "one-size fits all" paper).

The difference between processing and event-time starts to matter, optimistic execution whose results may be retracted later...

Being able to do incremental processing helps, but the full spectrum of low-frequency batch processing and line-rate stream processing is useful and needed.

A very desirable property would be to have declarative detection rules that work roughly the same, whether they are batch or stream processing.

Mangle as an extended datalog (with some tweaks, execution hints) may be useful, but beyond a certain point, scalable stream processing requires custom engineering for now (sharding, distribution, locality).

<!--

```
# suppose T1, T2 are timestamps in seconds since epoch UTC
first_A_then_B(H1, T1, T2) :- 
  eventA(H, T1),
  eventB(H, T2),
  T1 < T2,
  fn:minus(T2, T1) < 10 * 60.
```

Remarks:
- eventA can be a fact, but it could also be a rule (joining multiple facts) - compositionality
- Arithmetic function (T2 - T1) means we already extended datalog.
- High-level expression of query matters! These rules need to be understandable. Similar application areas: policy languages e.g. authorization, configuration.
- efficient execution matters, too, separate problem.
- at high volume, embarassingly parallel (e.g. distributed Beam programs, sharding)

-->
