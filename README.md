> WARNING: use [`adept_svg`](https://github.com/adept-bits/adept_svg) which is
>
> - fastest
> - zero deps

# InlineSVG

> An inline SVG renderer for everything.

## Features

- file system sensitive re-compilation
- high performance - parse and cache SVG at compile time, instead of runtime
- doesn't bind to Phoenix ecosystem

## Usage

Visit [InlineSVG](https://hexdocs.pm/inline_svg/InlineSVG.html) in [HexDocs](https://hexdocs.pm/inline_svg) for more details.

## Benchmark

TLDR;

```
Comparison:
adept_svg                8237.17
inline_svg                172.58 - 47.73x slower +5.67 ms
phoenix_inline_svg          1.92 - 4284.54x slower +520.03 ms
```

- The fastest is `adept_svg`.
- The slowest is `phoenix_inline_svg`.
- `inline_svg` is a joke, it is abandoned within a day of its completion. ;)

```
Operating System: macOS
CPU Information: Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz
Number of Available Cores: 12
Available memory: 16 GB
Elixir 1.13.3
Erlang 24.2

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
memory time: 0 ns
parallel: 1
inputs: 1. small SVG without attrs, 2. small SVG with 5 attrs (normal case), 3. small SVG with 25 attrs, 4.
small SVG with 100 attrs, 5. big SVG without attrs, 6. big SVG with 5 attrs (normal case), 7. big SVG with 2
5 attrs, 8. big SVG with 100 attrs
Estimated total run time: 2.80 min

Benchmarking adept_svg with input 1. small SVG without attrs...
Benchmarking adept_svg with input 2. small SVG with 5 attrs (normal case)...
Benchmarking adept_svg with input 3. small SVG with 25 attrs...
Benchmarking adept_svg with input 4. small SVG with 100 attrs...
Benchmarking adept_svg with input 5. big SVG without attrs...
Benchmarking adept_svg with input 6. big SVG with 5 attrs (normal case)...
Benchmarking adept_svg with input 7. big SVG with 25 attrs...
Benchmarking adept_svg with input 8. big SVG with 100 attrs...
Benchmarking inline_svg with input 1. small SVG without attrs...
Benchmarking inline_svg with input 2. small SVG with 5 attrs (normal case)...
Benchmarking inline_svg with input 3. small SVG with 25 attrs...
Benchmarking inline_svg with input 4. small SVG with 100 attrs...
Benchmarking inline_svg with input 5. big SVG without attrs...
Benchmarking inline_svg with input 6. big SVG with 5 attrs (normal case)...
Benchmarking inline_svg with input 7. big SVG with 25 attrs...
Benchmarking inline_svg with input 8. big SVG with 100 attrs...
Benchmarking phoenix_inline_svg with input 1. small SVG without attrs...
Benchmarking phoenix_inline_svg with input 2. small SVG with 5 attrs (normal case)...
Benchmarking phoenix_inline_svg with input 3. small SVG with 25 attrs...
Benchmarking phoenix_inline_svg with input 4. small SVG with 100 attrs...
Benchmarking phoenix_inline_svg with input 5. big SVG without attrs...
Benchmarking phoenix_inline_svg with input 6. big SVG with 5 attrs (normal case)...
Benchmarking phoenix_inline_svg with input 7. big SVG with 25 attrs...
Benchmarking phoenix_inline_svg with input 8. big SVG with 100 attrs...

##### With input 1. small SVG without attrs #####
Name                         ips        average  deviation         median         99th %
phoenix_inline_svg        4.52 M      221.14 ns ±11957.82%           0 ns         990 ns
inline_svg                4.33 M      230.85 ns ±12127.09%           0 ns         990 ns
adept_svg                 1.42 M      704.14 ns  ±4723.41%           0 ns         990 ns

Comparison:
phoenix_inline_svg        4.52 M
inline_svg                4.33 M - 1.04x slower +9.70 ns
adept_svg                 1.42 M - 3.18x slower +483.00 ns

##### With input 2. small SVG with 5 attrs (normal case) #####
Name                         ips        average  deviation         median         99th %
adept_svg               138.93 K        7.20 μs   ±276.35%        5.99 μs       27.99 μs
inline_svg               23.92 K       41.80 μs    ±37.24%       37.99 μs      119.99 μs
phoenix_inline_svg        5.30 K      188.78 μs    ±23.65%      177.99 μs      345.99 μs

Comparison:
adept_svg               138.93 K
inline_svg               23.92 K - 5.81x slower +34.61 μs
phoenix_inline_svg        5.30 K - 26.23x slower +181.58 μs

##### With input 3. small SVG with 25 attrs #####
Name                         ips        average  deviation         median         99th %
adept_svg                35.73 K       27.99 μs    ±35.98%       25.99 μs       71.99 μs
inline_svg                5.49 K      182.23 μs    ±27.60%      172.99 μs      329.99 μs
phoenix_inline_svg        1.04 K      960.40 μs    ±12.69%      934.99 μs     1399.06 μs

Comparison:
adept_svg                35.73 K
inline_svg                5.49 K - 6.51x slower +154.24 μs
phoenix_inline_svg        1.04 K - 34.31x slower +932.41 μs

##### With input 4. small SVG with 100 attrs #####
Name                         ips        average  deviation         median         99th %
adept_svg                 9.42 K      106.19 μs    ±18.15%      100.99 μs      205.99 μs
inline_svg                1.29 K      772.27 μs     ±9.15%      741.99 μs     1025.34 μs
phoenix_inline_svg       0.161 K     6224.93 μs     ±3.52%     6193.99 μs     6841.95 μs

Comparison:
adept_svg                 9.42 K
inline_svg                1.29 K - 7.27x slower +666.08 μs
phoenix_inline_svg       0.161 K - 58.62x slower +6118.74 μs

##### With input 5. big SVG without attrs #####
Name                         ips        average  deviation         median         99th %
phoenix_inline_svg        4.62 M      216.67 ns ±11734.37%           0 ns         990 ns
inline_svg                4.48 M      223.41 ns ±12459.01%           0 ns         990 ns
adept_svg                 0.33 M     2999.25 ns   ±653.43%        2990 ns        4990 ns

Comparison:
phoenix_inline_svg        4.62 M
inline_svg                4.48 M - 1.03x slower +6.74 ns
adept_svg                 0.33 M - 13.84x slower +2782.58 ns

##### With input 6. big SVG with 5 attrs (normal case) #####
Name                         ips        average  deviation         median         99th %
adept_svg                87.21 K       11.47 μs    ±75.52%        9.99 μs       40.99 μs
inline_svg                1.45 K      691.56 μs     ±9.92%      664.99 μs      963.67 μs
phoenix_inline_svg      0.0355 K    28159.01 μs    ±12.65%    29157.99 μs    41967.24 μs

Comparison:
adept_svg                87.21 K
inline_svg                1.45 K - 60.31x slower +680.09 μs
phoenix_inline_svg      0.0355 K - 2455.63x slower +28147.55 μs

##### With input 7. big SVG with 25 attrs #####
Name                         ips        average  deviation         median         99th %
adept_svg               28678.25      0.0349 ms    ±49.73%      0.0310 ms      0.0893 ms
inline_svg                538.18        1.86 ms     ±9.43%        1.83 ms        2.58 ms
phoenix_inline_svg          7.29      137.27 ms     ±3.86%      136.66 ms      149.68 ms

Comparison:
adept_svg               28678.25
inline_svg                538.18 - 53.29x slower +1.82 ms
phoenix_inline_svg          7.29 - 3936.58x slower +137.23 ms

##### With input 8. big SVG with 100 attrs #####
Name                         ips        average  deviation         median         99th %
adept_svg                8237.17       0.121 ms    ±35.19%       0.110 ms        0.25 ms
inline_svg                172.58        5.79 ms     ±5.67%        5.80 ms        6.64 ms
phoenix_inline_svg          1.92      520.15 ms     ±2.90%      516.70 ms      545.26 ms

Comparison:
adept_svg                8237.17
inline_svg                172.58 - 47.73x slower +5.67 ms
phoenix_inline_svg          1.92 - 4284.54x slower +520.03 ms
```

## License

Apache License 2.0
