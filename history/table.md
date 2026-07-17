|                                                       | a4fd9484caba33... |
|:------------------------------------------------------|:-----------------:|
| AD gradients/_gamma_cdf direct/Enzyme forward         | 7.53 ± 0.088 μs   |
| AD gradients/_gamma_cdf direct/Enzyme reverse         | 0.309 ± 0.018 μs  |
| AD gradients/_gamma_cdf direct/ForwardDiff            | 0.745 ± 0.093 μs  |
| AD gradients/_gamma_cdf direct/Mooncake forward       | 6.25 ± 0.47 μs    |
| AD gradients/_gamma_cdf direct/Mooncake reverse       | 5.14 ± 0.41 μs    |
| AD gradients/_gamma_cdf direct/ReverseDiff (tape)     | 0.903 ± 0.19 μs   |
| AD gradients/ccdf_ad_safe Gamma/Enzyme forward        | 9.63 ± 0.09 μs    |
| AD gradients/ccdf_ad_safe Gamma/Enzyme reverse        | 4.49 ± 0.084 μs   |
| AD gradients/ccdf_ad_safe Gamma/ForwardDiff           | 1.53 ± 0.015 μs   |
| AD gradients/ccdf_ad_safe Gamma/Mooncake forward      | 7.69 ± 0.2 μs     |
| AD gradients/ccdf_ad_safe Gamma/Mooncake reverse      | 22.2 ± 9.3 μs     |
| AD gradients/ccdf_ad_safe Gamma/ReverseDiff (tape)    | 6.58 ± 0.24 μs    |
| AD gradients/cdf_ad_safe Gamma/Enzyme forward         | 9.61 ± 0.1 μs     |
| AD gradients/cdf_ad_safe Gamma/Enzyme reverse         | 4.49 ± 0.077 μs   |
| AD gradients/cdf_ad_safe Gamma/ForwardDiff            | 1.5 ± 0.014 μs    |
| AD gradients/cdf_ad_safe Gamma/Mooncake forward       | 7.68 ± 0.17 μs    |
| AD gradients/cdf_ad_safe Gamma/Mooncake reverse       | 22 ± 8.8 μs       |
| AD gradients/cdf_ad_safe Gamma/ReverseDiff (tape)     | 4.75 ± 0.11 μs    |
| AD gradients/logccdf_ad_safe Gamma/Enzyme forward     | 9.65 ± 0.09 μs    |
| AD gradients/logccdf_ad_safe Gamma/Enzyme reverse     | 4.63 ± 0.09 μs    |
| AD gradients/logccdf_ad_safe Gamma/ForwardDiff        | 1.53 ± 0.014 μs   |
| AD gradients/logccdf_ad_safe Gamma/Mooncake forward   | 8.08 ± 0.21 μs    |
| AD gradients/logccdf_ad_safe Gamma/Mooncake reverse   | 22.3 ± 9.1 μs     |
| AD gradients/logccdf_ad_safe Gamma/ReverseDiff (tape) | 5.47 ± 0.88 μs    |
| AD gradients/logcdf_ad_safe Gamma/Enzyme forward      | 9.67 ± 0.1 μs     |
| AD gradients/logcdf_ad_safe Gamma/Enzyme reverse      | 4.57 ± 0.076 μs   |
| AD gradients/logcdf_ad_safe Gamma/ForwardDiff         | 1.55 ± 0.016 μs   |
| AD gradients/logcdf_ad_safe Gamma/Mooncake forward    | 8 ± 0.19 μs       |
| AD gradients/logcdf_ad_safe Gamma/Mooncake reverse    | 22.3 ± 9.1 μs     |
| AD gradients/logcdf_ad_safe Gamma/ReverseDiff (tape)  | 5.22 ± 0.52 μs    |
| AD gradients/pdf_ad_safe Gamma/Enzyme forward         | 8.45 ± 0.094 μs   |
| AD gradients/pdf_ad_safe Gamma/Enzyme reverse         | 3.43 ± 0.073 μs   |
| AD gradients/pdf_ad_safe Gamma/ForwardDiff            | 0.854 ± 0.093 μs  |
| AD gradients/pdf_ad_safe Gamma/Mooncake forward       | 6.21 ± 0.38 μs    |
| AD gradients/pdf_ad_safe Gamma/Mooncake reverse       | 28.3 ± 12 μs      |
| AD gradients/pdf_ad_safe Gamma/ReverseDiff (tape)     | 15.2 ± 0.42 μs    |
| Baseline/Gamma/ccdf                                   | 3.56 ± 0.38 μs    |
| Baseline/Gamma/cdf                                    | 3.57 ± 0.37 μs    |
| Baseline/Gamma/logccdf                                | 5.69 ± 0.069 μs   |
| Baseline/Gamma/logcdf                                 | 5.55 ± 0.067 μs   |
| Baseline/Gamma/pdf                                    | 4.2 ± 0.22 μs     |
| Hooks/Gamma/ccdf_ad_safe                              | 3.61 ± 0.38 μs    |
| Hooks/Gamma/cdf_ad_safe                               | 3.57 ± 0.37 μs    |
| Hooks/Gamma/logccdf_ad_safe                           | 5.33 ± 0.065 μs   |
| Hooks/Gamma/logcdf_ad_safe                            | 4.93 ± 0.23 μs    |
| Hooks/Gamma/pdf_ad_safe                               | 4.18 ± 0.23 μs    |
| Hooks/Normal (fall-through)/cdf_ad_safe               | 1.55 ± 0.32 μs    |
| Hooks/Normal (fall-through)/logcdf_ad_safe            | 3.97 ± 0.33 μs    |
| Hooks/Normal (fall-through)/pdf_ad_safe               | 1.08 ± 0.33 μs    |
| Hooks/_gamma_cdf/broadcast                            | 3.55 ± 0.37 μs    |
| Hooks/_gamma_cdf/scalar                               | 1.55 ± 0.009 ns   |
| time_to_load                                          | 0.515 ± 0.0059 s  |

|                                                       | a4fd9484caba33...         |
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

