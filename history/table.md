|                                                       | v0.1.0           | 8400c41028f79b... | v0.1.0 / 8400c41028f79b... |
|:------------------------------------------------------|:----------------:|:-----------------:|:--------------------------:|
| AD gradients/_gamma_cdf direct/Enzyme forward         | 7.57 ± 0.078 μs  | 7.52 ± 0.065 μs   | 1.01 ± 0.014               |
| AD gradients/_gamma_cdf direct/Enzyme reverse         | 0.308 ± 0.018 μs | 0.303 ± 0.018 μs  | 1.01 ± 0.084               |
| AD gradients/_gamma_cdf direct/ForwardDiff            | 0.749 ± 0.097 μs | 0.744 ± 0.097 μs  | 1.01 ± 0.19                |
| AD gradients/_gamma_cdf direct/Mooncake forward       | 6.12 ± 0.79 μs   | 6.03 ± 0.75 μs    | 1.01 ± 0.18                |
| AD gradients/_gamma_cdf direct/Mooncake reverse       | 5.05 ± 0.37 μs   | 5.02 ± 0.38 μs    | 1.01 ± 0.11                |
| AD gradients/_gamma_cdf direct/ReverseDiff (tape)     | 0.862 ± 0.19 μs  | 0.868 ± 0.19 μs   | 0.993 ± 0.31               |
| AD gradients/ccdf_ad_safe Gamma/Enzyme forward        | 9.53 ± 0.09 μs   | 9.48 ± 0.089 μs   | 1.01 ± 0.013               |
| AD gradients/ccdf_ad_safe Gamma/Enzyme reverse        | 4.41 ± 0.063 μs  | 4.4 ± 0.06 μs     | 1 ± 0.02                   |
| AD gradients/ccdf_ad_safe Gamma/ForwardDiff           | 1.51 ± 0.013 μs  | 1.52 ± 0.014 μs   | 0.995 ± 0.013              |
| AD gradients/ccdf_ad_safe Gamma/Mooncake forward      | 7.67 ± 0.14 μs   | 7.67 ± 0.14 μs    | 1 ± 0.026                  |
| AD gradients/ccdf_ad_safe Gamma/Mooncake reverse      | 21.7 ± 8.6 μs    | 21.7 ± 9 μs       | 0.997 ± 0.57               |
| AD gradients/ccdf_ad_safe Gamma/ReverseDiff (tape)    | 6.51 ± 0.19 μs   | 6.53 ± 0.19 μs    | 0.996 ± 0.042              |
| AD gradients/cdf_ad_safe Gamma/Enzyme forward         | 9.53 ± 0.09 μs   | 9.52 ± 0.1 μs     | 1 ± 0.014                  |
| AD gradients/cdf_ad_safe Gamma/Enzyme reverse         | 4.38 ± 0.067 μs  | 4.4 ± 0.067 μs    | 0.995 ± 0.022              |
| AD gradients/cdf_ad_safe Gamma/ForwardDiff            | 1.52 ± 0.013 μs  | 1.51 ± 0.012 μs   | 1.01 ± 0.012               |
| AD gradients/cdf_ad_safe Gamma/Mooncake forward       | 7.77 ± 0.16 μs   | 7.74 ± 0.15 μs    | 1 ± 0.028                  |
| AD gradients/cdf_ad_safe Gamma/Mooncake reverse       | 22.1 ± 9 μs      | 22 ± 8.9 μs       | 1.01 ± 0.58                |
| AD gradients/cdf_ad_safe Gamma/ReverseDiff (tape)     | 4.7 ± 0.089 μs   | 4.63 ± 0.086 μs   | 1.01 ± 0.027               |
| AD gradients/logccdf_ad_safe Gamma/Enzyme forward     | 9.59 ± 0.08 μs   | 9.55 ± 0.09 μs    | 1 ± 0.013                  |
| AD gradients/logccdf_ad_safe Gamma/Enzyme reverse     | 4.55 ± 0.066 μs  | 4.54 ± 0.076 μs   | 1 ± 0.022                  |
| AD gradients/logccdf_ad_safe Gamma/ForwardDiff        | 1.53 ± 0.014 μs  | 1.54 ± 0.012 μs   | 0.994 ± 0.012              |
| AD gradients/logccdf_ad_safe Gamma/Mooncake forward   | 8.04 ± 0.17 μs   | 8.06 ± 0.17 μs    | 0.998 ± 0.029              |
| AD gradients/logccdf_ad_safe Gamma/Mooncake reverse   | 22.3 ± 9 μs      | 22.2 ± 9.1 μs     | 1 ± 0.58                   |
| AD gradients/logccdf_ad_safe Gamma/ReverseDiff (tape) | 5.39 ± 0.86 μs   | 5.35 ± 0.89 μs    | 1.01 ± 0.23                |
| AD gradients/logcdf_ad_safe Gamma/Enzyme forward      | 9.54 ± 0.09 μs   | 9.57 ± 0.091 μs   | 0.997 ± 0.013              |
| AD gradients/logcdf_ad_safe Gamma/Enzyme reverse      | 4.52 ± 0.064 μs  | 4.57 ± 0.057 μs   | 0.989 ± 0.019              |
| AD gradients/logcdf_ad_safe Gamma/ForwardDiff         | 1.53 ± 0.013 μs  | 1.56 ± 0.011 μs   | 0.978 ± 0.011              |
| AD gradients/logcdf_ad_safe Gamma/Mooncake forward    | 7.94 ± 0.15 μs   | 7.92 ± 0.14 μs    | 1 ± 0.026                  |
| AD gradients/logcdf_ad_safe Gamma/Mooncake reverse    | 22 ± 9 μs        | 22.2 ± 9.2 μs     | 0.991 ± 0.58               |
| AD gradients/logcdf_ad_safe Gamma/ReverseDiff (tape)  | 5.11 ± 0.36 μs   | 5.07 ± 0.82 μs    | 1.01 ± 0.18                |
| AD gradients/pdf_ad_safe Gamma/Enzyme forward         | 8.37 ± 0.073 μs  | 8.46 ± 0.074 μs   | 0.989 ± 0.012              |
| AD gradients/pdf_ad_safe Gamma/Enzyme reverse         | 3.41 ± 0.055 μs  | 3.42 ± 0.055 μs   | 0.997 ± 0.023              |
| AD gradients/pdf_ad_safe Gamma/ForwardDiff            | 0.837 ± 0.09 μs  | 0.849 ± 0.09 μs   | 0.986 ± 0.15               |
| AD gradients/pdf_ad_safe Gamma/Mooncake forward       | 6.19 ± 0.38 μs   | 6.22 ± 0.31 μs    | 0.994 ± 0.079              |
| AD gradients/pdf_ad_safe Gamma/Mooncake reverse       | 27.9 ± 11 μs     | 27.9 ± 11 μs      | 1 ± 0.57                   |
| AD gradients/pdf_ad_safe Gamma/ReverseDiff (tape)     | 15.4 ± 0.42 μs   | 15.2 ± 0.38 μs    | 1.01 ± 0.038               |
| Baseline/Gamma/ccdf                                   | 3.59 ± 0.37 μs   | 3.57 ± 0.38 μs    | 1 ± 0.15                   |
| Baseline/Gamma/cdf                                    | 3.6 ± 0.37 μs    | 3.57 ± 0.38 μs    | 1.01 ± 0.15                |
| Baseline/Gamma/logccdf                                | 5.68 ± 0.065 μs  | 5.66 ± 0.035 μs   | 1 ± 0.013                  |
| Baseline/Gamma/logcdf                                 | 5.52 ± 0.065 μs  | 5.56 ± 0.044 μs   | 0.993 ± 0.014              |
| Baseline/Gamma/pdf                                    | 4.15 ± 0.21 μs   | 4.18 ± 0.2 μs     | 0.991 ± 0.068              |
| Hooks/Gamma/ccdf_ad_safe                              | 3.65 ± 0.36 μs   | 3.63 ± 0.36 μs    | 1.01 ± 0.14                |
| Hooks/Gamma/cdf_ad_safe                               | 3.6 ± 0.38 μs    | 3.57 ± 0.37 μs    | 1.01 ± 0.15                |
| Hooks/Gamma/logccdf_ad_safe                           | 5.34 ± 0.067 μs  | 5.33 ± 0.067 μs   | 1 ± 0.018                  |
| Hooks/Gamma/logcdf_ad_safe                            | 4.95 ± 0.21 μs   | 4.94 ± 0.21 μs    | 1 ± 0.06                   |
| Hooks/Gamma/pdf_ad_safe                               | 4.15 ± 0.21 μs   | 4.17 ± 0.21 μs    | 0.993 ± 0.07               |
| Hooks/Normal (fall-through)/cdf_ad_safe               | 1.7 ± 0.32 μs    | 1.5 ± 0.31 μs     | 1.14 ± 0.32                |
| Hooks/Normal (fall-through)/logcdf_ad_safe            | 3.98 ± 0.35 μs   | 3.94 ± 0.35 μs    | 1.01 ± 0.13                |
| Hooks/Normal (fall-through)/pdf_ad_safe               | 1.08 ± 0.33 μs   | 1.09 ± 0.33 μs    | 0.995 ± 0.43               |
| Hooks/_gamma_cdf/broadcast                            | 3.59 ± 0.36 μs   | 3.57 ± 0.36 μs    | 1 ± 0.14                   |
| Hooks/_gamma_cdf/scalar                               | 1.55 ± 0.01 ns   | 1.55 ± 0.009 ns   | 1 ± 0.0087                 |
| time_to_load                                          | 0.522 ± 0.0037 s | 0.501 ± 0.007 s   | 1.04 ± 0.016               |

|                                                       | v0.1.0                    | 8400c41028f79b...         | v0.1.0 / 8400c41028f79b... |
|:------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/_gamma_cdf direct/Enzyme forward         | 30  allocs: 1.06 kB       | 30  allocs: 1.06 kB       | 1                          |
| AD gradients/_gamma_cdf direct/Enzyme reverse         | 2  allocs: 0.0781 kB      | 2  allocs: 0.0781 kB      | 1                          |
| AD gradients/_gamma_cdf direct/ForwardDiff            | 7  allocs: 0.359 kB       | 7  allocs: 0.359 kB       | 1                          |
| AD gradients/_gamma_cdf direct/Mooncake forward       | 0.064 k allocs: 3.06 kB   | 0.064 k allocs: 3.06 kB   | 1                          |
| AD gradients/_gamma_cdf direct/Mooncake reverse       | 0.064 k allocs: 2.9 kB    | 0.064 k allocs: 2.9 kB    | 1                          |
| AD gradients/_gamma_cdf direct/ReverseDiff (tape)     | 16  allocs: 0.656 kB      | 16  allocs: 0.656 kB      | 1                          |
| AD gradients/ccdf_ad_safe Gamma/Enzyme forward        | 0.036 k allocs: 1.11 kB   | 0.036 k allocs: 1.11 kB   | 1                          |
| AD gradients/ccdf_ad_safe Gamma/Enzyme reverse        | 24  allocs: 1 kB          | 24  allocs: 1 kB          | 1                          |
| AD gradients/ccdf_ad_safe Gamma/ForwardDiff           | 7  allocs: 0.266 kB       | 7  allocs: 0.266 kB       | 1                          |
| AD gradients/ccdf_ad_safe Gamma/Mooncake forward      | 0.058 k allocs: 2.91 kB   | 0.058 k allocs: 2.91 kB   | 1                          |
| AD gradients/ccdf_ad_safe Gamma/Mooncake reverse      | 0.217 k allocs: 26 kB     | 0.217 k allocs: 26 kB     | 1                          |
| AD gradients/ccdf_ad_safe Gamma/ReverseDiff (tape)    | 0.082 k allocs: 3.55 kB   | 0.082 k allocs: 3.55 kB   | 1                          |
| AD gradients/cdf_ad_safe Gamma/Enzyme forward         | 0.036 k allocs: 1.11 kB   | 0.036 k allocs: 1.11 kB   | 1                          |
| AD gradients/cdf_ad_safe Gamma/Enzyme reverse         | 24  allocs: 1 kB          | 24  allocs: 1 kB          | 1                          |
| AD gradients/cdf_ad_safe Gamma/ForwardDiff            | 7  allocs: 0.266 kB       | 7  allocs: 0.266 kB       | 1                          |
| AD gradients/cdf_ad_safe Gamma/Mooncake forward       | 0.058 k allocs: 2.91 kB   | 0.058 k allocs: 2.91 kB   | 1                          |
| AD gradients/cdf_ad_safe Gamma/Mooncake reverse       | 0.217 k allocs: 26 kB     | 0.217 k allocs: 26 kB     | 1                          |
| AD gradients/cdf_ad_safe Gamma/ReverseDiff (tape)     | 0.061 k allocs: 2.47 kB   | 0.061 k allocs: 2.47 kB   | 1                          |
| AD gradients/logccdf_ad_safe Gamma/Enzyme forward     | 0.036 k allocs: 1.11 kB   | 0.036 k allocs: 1.11 kB   | 1                          |
| AD gradients/logccdf_ad_safe Gamma/Enzyme reverse     | 24  allocs: 1.03 kB       | 24  allocs: 1.03 kB       | 1                          |
| AD gradients/logccdf_ad_safe Gamma/ForwardDiff        | 7  allocs: 0.266 kB       | 7  allocs: 0.266 kB       | 1                          |
| AD gradients/logccdf_ad_safe Gamma/Mooncake forward   | 0.058 k allocs: 2.91 kB   | 0.058 k allocs: 2.91 kB   | 1                          |
| AD gradients/logccdf_ad_safe Gamma/Mooncake reverse   | 0.218 k allocs: 26.2 kB   | 0.218 k allocs: 26.2 kB   | 1                          |
| AD gradients/logccdf_ad_safe Gamma/ReverseDiff (tape) | 0.093 k allocs: 3.75 kB   | 0.093 k allocs: 3.75 kB   | 1                          |
| AD gradients/logcdf_ad_safe Gamma/Enzyme forward      | 0.036 k allocs: 1.11 kB   | 0.036 k allocs: 1.11 kB   | 1                          |
| AD gradients/logcdf_ad_safe Gamma/Enzyme reverse      | 24  allocs: 1.03 kB       | 24  allocs: 1.03 kB       | 1                          |
| AD gradients/logcdf_ad_safe Gamma/ForwardDiff         | 7  allocs: 0.266 kB       | 7  allocs: 0.266 kB       | 1                          |
| AD gradients/logcdf_ad_safe Gamma/Mooncake forward    | 0.058 k allocs: 2.91 kB   | 0.058 k allocs: 2.91 kB   | 1                          |
| AD gradients/logcdf_ad_safe Gamma/Mooncake reverse    | 0.218 k allocs: 26.2 kB   | 0.218 k allocs: 26.2 kB   | 1                          |
| AD gradients/logcdf_ad_safe Gamma/ReverseDiff (tape)  | 0.078 k allocs: 3.28 kB   | 0.078 k allocs: 3.28 kB   | 1                          |
| AD gradients/pdf_ad_safe Gamma/Enzyme forward         | 0.036 k allocs: 1.11 kB   | 0.036 k allocs: 1.11 kB   | 1                          |
| AD gradients/pdf_ad_safe Gamma/Enzyme reverse         | 24  allocs: 1.03 kB       | 24  allocs: 1.03 kB       | 1                          |
| AD gradients/pdf_ad_safe Gamma/ForwardDiff            | 7  allocs: 0.266 kB       | 7  allocs: 0.266 kB       | 1                          |
| AD gradients/pdf_ad_safe Gamma/Mooncake forward       | 0.058 k allocs: 2.91 kB   | 0.058 k allocs: 2.91 kB   | 1                          |
| AD gradients/pdf_ad_safe Gamma/Mooncake reverse       | 0.283 k allocs: 0.0323 MB | 0.283 k allocs: 0.0323 MB | 1                          |
| AD gradients/pdf_ad_safe Gamma/ReverseDiff (tape)     | 0.243 k allocs: 10.4 kB   | 0.243 k allocs: 10.4 kB   | 1                          |
| Baseline/Gamma/ccdf                                   | 2  allocs: 0.906 kB       | 2  allocs: 0.906 kB       | 1                          |
| Baseline/Gamma/cdf                                    | 2  allocs: 0.906 kB       | 2  allocs: 0.906 kB       | 1                          |
| Baseline/Gamma/logccdf                                | 2  allocs: 0.906 kB       | 2  allocs: 0.906 kB       | 1                          |
| Baseline/Gamma/logcdf                                 | 2  allocs: 0.906 kB       | 2  allocs: 0.906 kB       | 1                          |
| Baseline/Gamma/pdf                                    | 2  allocs: 0.906 kB       | 2  allocs: 0.906 kB       | 1                          |
| Hooks/Gamma/ccdf_ad_safe                              | 2  allocs: 0.906 kB       | 2  allocs: 0.906 kB       | 1                          |
| Hooks/Gamma/cdf_ad_safe                               | 2  allocs: 0.906 kB       | 2  allocs: 0.906 kB       | 1                          |
| Hooks/Gamma/logccdf_ad_safe                           | 2  allocs: 0.906 kB       | 2  allocs: 0.906 kB       | 1                          |
| Hooks/Gamma/logcdf_ad_safe                            | 2  allocs: 0.906 kB       | 2  allocs: 0.906 kB       | 1                          |
| Hooks/Gamma/pdf_ad_safe                               | 2  allocs: 0.906 kB       | 2  allocs: 0.906 kB       | 1                          |
| Hooks/Normal (fall-through)/cdf_ad_safe               | 2  allocs: 0.906 kB       | 2  allocs: 0.906 kB       | 1                          |
| Hooks/Normal (fall-through)/logcdf_ad_safe            | 2  allocs: 0.906 kB       | 2  allocs: 0.906 kB       | 1                          |
| Hooks/Normal (fall-through)/pdf_ad_safe               | 2  allocs: 0.906 kB       | 2  allocs: 0.906 kB       | 1                          |
| Hooks/_gamma_cdf/broadcast                            | 2  allocs: 0.906 kB       | 2  allocs: 0.906 kB       | 1                          |
| Hooks/_gamma_cdf/scalar                               | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| time_to_load                                          | 0.15 k allocs: 11.7 kB    | 0.15 k allocs: 11.7 kB    | 1                          |

