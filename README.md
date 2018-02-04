# Parser Benchmarks

Objective: parse link and title pairs from the `bench.html` file.

Please open an issue if you know how to improve any of the benchmarks.

Unfortunately I can't add the `bench.html` file to this repo because it is encumbered by copyright.
The `bench.html` is a snapshot of https://tweakers.net/ (a dutch technology website).

## uu-parsinglib

```
benchmarking UUParser
time                 1.681 ms   (1.671 ms .. 1.695 ms)
                     0.999 R²   (0.999 R² .. 1.000 R²)
mean                 1.648 ms   (1.639 ms .. 1.659 ms)
std dev              32.00 μs   (24.70 μs .. 45.86 μs)
```

## attoparsec

```
benchmarking AttoParser
time                 620.9 μs   (612.9 μs .. 630.2 μs)
                     0.999 R²   (0.999 R² .. 1.000 R²)
mean                 607.5 μs   (603.6 μs .. 612.3 μs)
std dev              15.01 μs   (11.28 μs .. 18.79 μs)
```
