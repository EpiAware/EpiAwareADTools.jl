|                                                       | 692ca8e6bde69d... |
|:------------------------------------------------------|:-----------------:|
| AD gradients/_gamma_cdf direct/Enzyme forward         | 7.49 ± 0.068 μs   |
| AD gradients/_gamma_cdf direct/Enzyme reverse         | 0.306 ± 0.018 μs  |
| AD gradients/_gamma_cdf direct/ForwardDiff            | 0.756 ± 0.1 μs    |
| AD gradients/_gamma_cdf direct/Mooncake forward       | 6.05 ± 0.74 μs    |
| AD gradients/_gamma_cdf direct/Mooncake reverse       | 5 ± 0.35 μs       |
| AD gradients/_gamma_cdf direct/ReverseDiff (tape)     | 0.864 ± 0.19 μs   |
| AD gradients/ccdf_ad_safe Gamma/Enzyme forward        | 9.49 ± 0.09 μs    |
| AD gradients/ccdf_ad_safe Gamma/Enzyme reverse        | 4.5 ± 0.062 μs    |
| AD gradients/ccdf_ad_safe Gamma/ForwardDiff           | 1.51 ± 0.011 μs   |
| AD gradients/ccdf_ad_safe Gamma/Mooncake forward      | 7.73 ± 0.13 μs    |
| AD gradients/ccdf_ad_safe Gamma/Mooncake reverse      | 21.7 ± 8.7 μs     |
| AD gradients/ccdf_ad_safe Gamma/ReverseDiff (tape)    | 6.53 ± 0.21 μs    |
| AD gradients/cdf_ad_safe Gamma/Enzyme forward         | 9.51 ± 0.08 μs    |
| AD gradients/cdf_ad_safe Gamma/Enzyme reverse         | 4.49 ± 0.059 μs   |
| AD gradients/cdf_ad_safe Gamma/ForwardDiff            | 1.51 ± 0.015 μs   |
| AD gradients/cdf_ad_safe Gamma/Mooncake forward       | 7.76 ± 0.16 μs    |
| AD gradients/cdf_ad_safe Gamma/Mooncake reverse       | 22.1 ± 8.8 μs     |
| AD gradients/cdf_ad_safe Gamma/ReverseDiff (tape)     | 4.74 ± 0.086 μs   |
| AD gradients/logccdf_ad_safe Gamma/Enzyme forward     | 9.54 ± 0.09 μs    |
| AD gradients/logccdf_ad_safe Gamma/Enzyme reverse     | 4.71 ± 0.067 μs   |
| AD gradients/logccdf_ad_safe Gamma/ForwardDiff        | 1.54 ± 0.011 μs   |
| AD gradients/logccdf_ad_safe Gamma/Mooncake forward   | 7.98 ± 0.14 μs    |
| AD gradients/logccdf_ad_safe Gamma/Mooncake reverse   | 22.3 ± 8.7 μs     |
| AD gradients/logccdf_ad_safe Gamma/ReverseDiff (tape) | 5.38 ± 0.9 μs     |
| AD gradients/logcdf_ad_safe Gamma/Enzyme forward      | 9.54 ± 0.09 μs    |
| AD gradients/logcdf_ad_safe Gamma/Enzyme reverse      | 4.61 ± 0.057 μs   |
| AD gradients/logcdf_ad_safe Gamma/ForwardDiff         | 1.54 ± 0.012 μs   |
| AD gradients/logcdf_ad_safe Gamma/Mooncake forward    | 7.97 ± 0.13 μs    |
| AD gradients/logcdf_ad_safe Gamma/Mooncake reverse    | 22.2 ± 8.9 μs     |
| AD gradients/logcdf_ad_safe Gamma/ReverseDiff (tape)  | 5.13 ± 0.57 μs    |
| AD gradients/pdf_ad_safe Gamma/Enzyme forward         | 8.33 ± 0.056 μs   |
| AD gradients/pdf_ad_safe Gamma/Enzyme reverse         | 3.55 ± 0.056 μs   |
| AD gradients/pdf_ad_safe Gamma/ForwardDiff            | 0.837 ± 0.088 μs  |
| AD gradients/pdf_ad_safe Gamma/Mooncake forward       | 6.21 ± 0.33 μs    |
| AD gradients/pdf_ad_safe Gamma/Mooncake reverse       | 27.7 ± 11 μs      |
| AD gradients/pdf_ad_safe Gamma/ReverseDiff (tape)     | 15.7 ± 0.35 μs    |
| Baseline/Gamma/ccdf                                   | 3.55 ± 0.38 μs    |
| Baseline/Gamma/cdf                                    | 3.58 ± 0.38 μs    |
| Baseline/Gamma/logccdf                                | 5.67 ± 0.057 μs   |
| Baseline/Gamma/logcdf                                 | 5.56 ± 0.057 μs   |
| Baseline/Gamma/pdf                                    | 4.3 ± 0.21 μs     |
| Hooks/Gamma/ccdf_ad_safe                              | 3.6 ± 0.38 μs     |
| Hooks/Gamma/cdf_ad_safe                               | 3.56 ± 0.38 μs    |
| Hooks/Gamma/logccdf_ad_safe                           | 5.34 ± 0.065 μs   |
| Hooks/Gamma/logcdf_ad_safe                            | 4.93 ± 0.21 μs    |
| Hooks/Gamma/pdf_ad_safe                               | 4.3 ± 0.21 μs     |
| Hooks/Normal (fall-through)/cdf_ad_safe               | 1.49 ± 0.31 μs    |
| Hooks/Normal (fall-through)/logcdf_ad_safe            | 3.95 ± 0.35 μs    |
| Hooks/Normal (fall-through)/pdf_ad_safe               | 1.09 ± 0.34 μs    |
| Hooks/_gamma_cdf/broadcast                            | 3.56 ± 0.38 μs    |
| Hooks/_gamma_cdf/scalar                               | 1.55 ± 0.01 ns    |
| time_to_load                                          | 0.489 ± 0.0062 s  |

|                                                       | 692ca8e6bde69d...         |
|:------------------------------------------------------|:-------------------------:|
| AD gradients/_gamma_cdf direct/Enzyme forward         | 30  allocs: 1.06 kB       |
| AD gradients/_gamma_cdf direct/Enzyme reverse         | 2  allocs: 0.0781 kB      |
| AD gradients/_gamma_cdf direct/ForwardDiff            | 7  allocs: 0.359 kB       |
| AD gradients/_gamma_cdf direct/Mooncake forward       | 0.064 k allocs: 3.06 kB   |
| AD gradients/_gamma_cdf direct/Mooncake reverse       | 0.064 k allocs: 2.9 kB    |
| AD gradients/_gamma_cdf direct/ReverseDiff (tape)     | 16  allocs: 0.656 kB      |
| AD gradients/ccdf_ad_safe Gamma/Enzyme forward        | 0.036 k allocs: 1.11 kB   |
| AD gradients/ccdf_ad_safe Gamma/Enzyme reverse        | 24  allocs: 1 kB          |
| AD gradients/ccdf_ad_safe Gamma/ForwardDiff           | 7  allocs: 0.266 kB       |
| AD gradients/ccdf_ad_safe Gamma/Mooncake forward      | 0.058 k allocs: 2.91 kB   |
| AD gradients/ccdf_ad_safe Gamma/Mooncake reverse      | 0.217 k allocs: 26 kB     |
| AD gradients/ccdf_ad_safe Gamma/ReverseDiff (tape)    | 0.082 k allocs: 3.55 kB   |
| AD gradients/cdf_ad_safe Gamma/Enzyme forward         | 0.036 k allocs: 1.11 kB   |
| AD gradients/cdf_ad_safe Gamma/Enzyme reverse         | 24  allocs: 1 kB          |
| AD gradients/cdf_ad_safe Gamma/ForwardDiff            | 7  allocs: 0.266 kB       |
| AD gradients/cdf_ad_safe Gamma/Mooncake forward       | 0.058 k allocs: 2.91 kB   |
| AD gradients/cdf_ad_safe Gamma/Mooncake reverse       | 0.217 k allocs: 26 kB     |
| AD gradients/cdf_ad_safe Gamma/ReverseDiff (tape)     | 0.061 k allocs: 2.47 kB   |
| AD gradients/logccdf_ad_safe Gamma/Enzyme forward     | 0.036 k allocs: 1.11 kB   |
| AD gradients/logccdf_ad_safe Gamma/Enzyme reverse     | 24  allocs: 1.03 kB       |
| AD gradients/logccdf_ad_safe Gamma/ForwardDiff        | 7  allocs: 0.266 kB       |
| AD gradients/logccdf_ad_safe Gamma/Mooncake forward   | 0.058 k allocs: 2.91 kB   |
| AD gradients/logccdf_ad_safe Gamma/Mooncake reverse   | 0.218 k allocs: 26.2 kB   |
| AD gradients/logccdf_ad_safe Gamma/ReverseDiff (tape) | 0.093 k allocs: 3.75 kB   |
| AD gradients/logcdf_ad_safe Gamma/Enzyme forward      | 0.036 k allocs: 1.11 kB   |
| AD gradients/logcdf_ad_safe Gamma/Enzyme reverse      | 24  allocs: 1.03 kB       |
| AD gradients/logcdf_ad_safe Gamma/ForwardDiff         | 7  allocs: 0.266 kB       |
| AD gradients/logcdf_ad_safe Gamma/Mooncake forward    | 0.058 k allocs: 2.91 kB   |
| AD gradients/logcdf_ad_safe Gamma/Mooncake reverse    | 0.218 k allocs: 26.2 kB   |
| AD gradients/logcdf_ad_safe Gamma/ReverseDiff (tape)  | 0.078 k allocs: 3.28 kB   |
| AD gradients/pdf_ad_safe Gamma/Enzyme forward         | 0.036 k allocs: 1.11 kB   |
| AD gradients/pdf_ad_safe Gamma/Enzyme reverse         | 24  allocs: 1.03 kB       |
| AD gradients/pdf_ad_safe Gamma/ForwardDiff            | 7  allocs: 0.266 kB       |
| AD gradients/pdf_ad_safe Gamma/Mooncake forward       | 0.058 k allocs: 2.91 kB   |
| AD gradients/pdf_ad_safe Gamma/Mooncake reverse       | 0.283 k allocs: 0.0323 MB |
| AD gradients/pdf_ad_safe Gamma/ReverseDiff (tape)     | 0.243 k allocs: 10.4 kB   |
| Baseline/Gamma/ccdf                                   | 2  allocs: 0.906 kB       |
| Baseline/Gamma/cdf                                    | 2  allocs: 0.906 kB       |
| Baseline/Gamma/logccdf                                | 2  allocs: 0.906 kB       |
| Baseline/Gamma/logcdf                                 | 2  allocs: 0.906 kB       |
| Baseline/Gamma/pdf                                    | 2  allocs: 0.906 kB       |
| Hooks/Gamma/ccdf_ad_safe                              | 2  allocs: 0.906 kB       |
| Hooks/Gamma/cdf_ad_safe                               | 2  allocs: 0.906 kB       |
| Hooks/Gamma/logccdf_ad_safe                           | 2  allocs: 0.906 kB       |
| Hooks/Gamma/logcdf_ad_safe                            | 2  allocs: 0.906 kB       |
| Hooks/Gamma/pdf_ad_safe                               | 2  allocs: 0.906 kB       |
| Hooks/Normal (fall-through)/cdf_ad_safe               | 2  allocs: 0.906 kB       |
| Hooks/Normal (fall-through)/logcdf_ad_safe            | 2  allocs: 0.906 kB       |
| Hooks/Normal (fall-through)/pdf_ad_safe               | 2  allocs: 0.906 kB       |
| Hooks/_gamma_cdf/broadcast                            | 2  allocs: 0.906 kB       |
| Hooks/_gamma_cdf/scalar                               | 0  allocs: 0 B            |
| time_to_load                                          | 0.15 k allocs: 11.7 kB    |

