|                                                       | 3fa83a1318c526... |
|:------------------------------------------------------|:-----------------:|
| AD gradients/_gamma_cdf direct/Enzyme forward         | 5.55 ± 0.061 μs   |
| AD gradients/_gamma_cdf direct/Enzyme reverse         | 0.213 ± 0.018 μs  |
| AD gradients/_gamma_cdf direct/ForwardDiff            | 0.564 ± 0.048 μs  |
| AD gradients/_gamma_cdf direct/Mooncake forward       | 4.81 ± 0.62 μs    |
| AD gradients/_gamma_cdf direct/Mooncake reverse       | 3.78 ± 0.39 μs    |
| AD gradients/_gamma_cdf direct/ReverseDiff (tape)     | 0.746 ± 0.15 μs   |
| AD gradients/ccdf_ad_safe Gamma/Enzyme forward        | 6.98 ± 0.075 μs   |
| AD gradients/ccdf_ad_safe Gamma/Enzyme reverse        | 3.45 ± 0.064 μs   |
| AD gradients/ccdf_ad_safe Gamma/ForwardDiff           | 1.07 ± 0.018 μs   |
| AD gradients/ccdf_ad_safe Gamma/Mooncake forward      | 5.81 ± 0.46 μs    |
| AD gradients/ccdf_ad_safe Gamma/Mooncake reverse      | 16.3 ± 5.3 μs     |
| AD gradients/ccdf_ad_safe Gamma/ReverseDiff (tape)    | 5.35 ± 0.58 μs    |
| AD gradients/cdf_ad_safe Gamma/Enzyme forward         | 6.95 ± 0.067 μs   |
| AD gradients/cdf_ad_safe Gamma/Enzyme reverse         | 3.43 ± 0.093 μs   |
| AD gradients/cdf_ad_safe Gamma/ForwardDiff            | 1.09 ± 0.036 μs   |
| AD gradients/cdf_ad_safe Gamma/Mooncake forward       | 5.75 ± 0.51 μs    |
| AD gradients/cdf_ad_safe Gamma/Mooncake reverse       | 16.2 ± 5.2 μs     |
| AD gradients/cdf_ad_safe Gamma/ReverseDiff (tape)     | 3.71 ± 0.3 μs     |
| AD gradients/logccdf_ad_safe Gamma/Enzyme forward     | 7.07 ± 0.26 μs    |
| AD gradients/logccdf_ad_safe Gamma/Enzyme reverse     | 3.53 ± 0.072 μs   |
| AD gradients/logccdf_ad_safe Gamma/ForwardDiff        | 1.12 ± 0.025 μs   |
| AD gradients/logccdf_ad_safe Gamma/Mooncake forward   | 6.06 ± 0.54 μs    |
| AD gradients/logccdf_ad_safe Gamma/Mooncake reverse   | 17.1 ± 5.4 μs     |
| AD gradients/logccdf_ad_safe Gamma/ReverseDiff (tape) | 4.43 ± 0.64 μs    |
| AD gradients/logcdf_ad_safe Gamma/Enzyme forward      | 7.01 ± 0.056 μs   |
| AD gradients/logcdf_ad_safe Gamma/Enzyme reverse      | 3.51 ± 0.069 μs   |
| AD gradients/logcdf_ad_safe Gamma/ForwardDiff         | 1.1 ± 0.015 μs    |
| AD gradients/logcdf_ad_safe Gamma/Mooncake forward    | 5.92 ± 0.46 μs    |
| AD gradients/logcdf_ad_safe Gamma/Mooncake reverse    | 16.4 ± 5.3 μs     |
| AD gradients/logcdf_ad_safe Gamma/ReverseDiff (tape)  | 4.18 ± 0.57 μs    |
| AD gradients/pdf_ad_safe Gamma/Enzyme forward         | 6.24 ± 0.063 μs   |
| AD gradients/pdf_ad_safe Gamma/Enzyme reverse         | 2.73 ± 0.082 μs   |
| AD gradients/pdf_ad_safe Gamma/ForwardDiff            | 0.559 ± 0.061 μs  |
| AD gradients/pdf_ad_safe Gamma/Mooncake forward       | 4.93 ± 0.61 μs    |
| AD gradients/pdf_ad_safe Gamma/Mooncake reverse       | 20.8 ± 7.4 μs     |
| AD gradients/pdf_ad_safe Gamma/ReverseDiff (tape)     | 12.3 ± 0.84 μs    |
| Baseline/Gamma/ccdf                                   | 2.45 ± 0.23 μs    |
| Baseline/Gamma/cdf                                    | 2.5 ± 0.22 μs     |
| Baseline/Gamma/logccdf                                | 4.22 ± 0.24 μs    |
| Baseline/Gamma/logcdf                                 | 4.22 ± 0.23 μs    |
| Baseline/Gamma/pdf                                    | 2.7 ± 0.28 μs     |
| Hooks/Gamma/ccdf_ad_safe                              | 2.49 ± 0.22 μs    |
| Hooks/Gamma/cdf_ad_safe                               | 2.54 ± 0.29 μs    |
| Hooks/Gamma/logccdf_ad_safe                           | 4.12 ± 0.16 μs    |
| Hooks/Gamma/logcdf_ad_safe                            | 4.02 ± 0.24 μs    |
| Hooks/Gamma/pdf_ad_safe                               | 2.7 ± 0.26 μs     |
| Hooks/Normal (fall-through)/cdf_ad_safe               | 1.18 ± 0.22 μs    |
| Hooks/Normal (fall-through)/logcdf_ad_safe            | 3.02 ± 0.26 μs    |
| Hooks/Normal (fall-through)/pdf_ad_safe               | 0.741 ± 0.26 μs   |
| Hooks/_gamma_cdf/broadcast                            | 2.47 ± 0.21 μs    |
| Hooks/_gamma_cdf/scalar                               | 1.13 ± 0.017 ns   |
| time_to_load                                          | 0.423 ± 0.002 s   |

|                                                       | 3fa83a1318c526...         |
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

