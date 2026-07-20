|                                                       | v0.1.0            | fa90e6a4370adf... | v0.1.0 / fa90e6a4370adf... |
|:------------------------------------------------------|:-----------------:|:-----------------:|:--------------------------:|
| AD gradients/_gamma_cdf direct/Enzyme forward         | 7.1 ± 0.12 μs     | 7.13 ± 0.1 μs     | 0.995 ± 0.022              |
| AD gradients/_gamma_cdf direct/Enzyme reverse         | 0.306 ± 0.021 μs  | 0.306 ± 0.021 μs  | 1 ± 0.098                  |
| AD gradients/_gamma_cdf direct/ForwardDiff            | 0.805 ± 0.12 μs   | 0.805 ± 0.12 μs   | 1 ± 0.22                   |
| AD gradients/_gamma_cdf direct/Mooncake forward       | 6.3 ± 0.38 μs     | 6.22 ± 0.26 μs    | 1.01 ± 0.074               |
| AD gradients/_gamma_cdf direct/Mooncake reverse       | 5.3 ± 0.22 μs     | 5.27 ± 0.18 μs    | 1.01 ± 0.055               |
| AD gradients/_gamma_cdf direct/ReverseDiff (tape)     | 0.896 ± 0.23 μs   | 0.966 ± 0.23 μs   | 0.928 ± 0.32               |
| AD gradients/ccdf_ad_safe Gamma/Enzyme forward        | 9.12 ± 0.17 μs    | 9.14 ± 0.15 μs    | 0.998 ± 0.025              |
| AD gradients/ccdf_ad_safe Gamma/Enzyme reverse        | 4.52 ± 0.11 μs    | 4.44 ± 0.1 μs     | 1.02 ± 0.034               |
| AD gradients/ccdf_ad_safe Gamma/ForwardDiff           | 1.59 ± 0.023 μs   | 1.56 ± 0.021 μs   | 1.02 ± 0.02                |
| AD gradients/ccdf_ad_safe Gamma/Mooncake forward      | 8.08 ± 0.2 μs     | 8.02 ± 0.18 μs    | 1.01 ± 0.034               |
| AD gradients/ccdf_ad_safe Gamma/Mooncake reverse      | 23.2 ± 9.1 μs     | 23.3 ± 8.8 μs     | 0.994 ± 0.54               |
| AD gradients/ccdf_ad_safe Gamma/ReverseDiff (tape)    | 6.51 ± 0.31 μs    | 6.48 ± 0.2 μs     | 1 ± 0.057                  |
| AD gradients/cdf_ad_safe Gamma/Enzyme forward         | 9.09 ± 0.14 μs    | 9.05 ± 0.13 μs    | 1 ± 0.021                  |
| AD gradients/cdf_ad_safe Gamma/Enzyme reverse         | 4.51 ± 0.11 μs    | 4.41 ± 0.096 μs   | 1.02 ± 0.034               |
| AD gradients/cdf_ad_safe Gamma/ForwardDiff            | 1.56 ± 0.029 μs   | 1.55 ± 0.018 μs   | 1 ± 0.022                  |
| AD gradients/cdf_ad_safe Gamma/Mooncake forward       | 8.12 ± 0.26 μs    | 8.04 ± 0.22 μs    | 1.01 ± 0.042               |
| AD gradients/cdf_ad_safe Gamma/Mooncake reverse       | 23.2 ± 9.1 μs     | 23 ± 8.8 μs       | 1.01 ± 0.55                |
| AD gradients/cdf_ad_safe Gamma/ReverseDiff (tape)     | 4.67 ± 0.13 μs    | 4.59 ± 0.12 μs    | 1.02 ± 0.039               |
| AD gradients/logccdf_ad_safe Gamma/Enzyme forward     | 9.18 ± 0.18 μs    | 9.19 ± 0.17 μs    | 0.999 ± 0.027              |
| AD gradients/logccdf_ad_safe Gamma/Enzyme reverse     | 4.66 ± 0.11 μs    | 4.58 ± 0.094 μs   | 1.02 ± 0.031               |
| AD gradients/logccdf_ad_safe Gamma/ForwardDiff        | 1.58 ± 0.024 μs   | 1.57 ± 0.023 μs   | 1.01 ± 0.021               |
| AD gradients/logccdf_ad_safe Gamma/Mooncake forward   | 8.37 ± 0.21 μs    | 8.29 ± 0.19 μs    | 1.01 ± 0.034               |
| AD gradients/logccdf_ad_safe Gamma/Mooncake reverse   | 23.5 ± 9.1 μs     | 23.7 ± 9.1 μs     | 0.99 ± 0.54                |
| AD gradients/logccdf_ad_safe Gamma/ReverseDiff (tape) | 5.29 ± 1.1 μs     | 5.21 ± 1.2 μs     | 1.02 ± 0.31                |
| AD gradients/logcdf_ad_safe Gamma/Enzyme forward      | 9.15 ± 0.18 μs    | 9.15 ± 0.19 μs    | 1 ± 0.029                  |
| AD gradients/logcdf_ad_safe Gamma/Enzyme reverse      | 4.6 ± 0.11 μs     | 4.59 ± 0.1 μs     | 1 ± 0.032                  |
| AD gradients/logcdf_ad_safe Gamma/ForwardDiff         | 1.57 ± 0.025 μs   | 1.56 ± 0.024 μs   | 1 ± 0.022                  |
| AD gradients/logcdf_ad_safe Gamma/Mooncake forward    | 8.33 ± 0.23 μs    | 8.32 ± 0.23 μs    | 1 ± 0.04                   |
| AD gradients/logcdf_ad_safe Gamma/Mooncake reverse    | 23.2 ± 9 μs       | 22.9 ± 8.4 μs     | 1.01 ± 0.54                |
| AD gradients/logcdf_ad_safe Gamma/ReverseDiff (tape)  | 5.04 ± 0.98 μs    | 5.06 ± 0.99 μs    | 0.995 ± 0.27               |
| AD gradients/pdf_ad_safe Gamma/Enzyme forward         | 8.02 ± 0.12 μs    | 8.01 ± 0.12 μs    | 1 ± 0.021                  |
| AD gradients/pdf_ad_safe Gamma/Enzyme reverse         | 3.45 ± 0.096 μs   | 3.37 ± 0.081 μs   | 1.02 ± 0.038               |
| AD gradients/pdf_ad_safe Gamma/ForwardDiff            | 0.852 ± 0.078 μs  | 0.843 ± 0.099 μs  | 1.01 ± 0.15                |
| AD gradients/pdf_ad_safe Gamma/Mooncake forward       | 6.45 ± 0.41 μs    | 6.5 ± 0.38 μs     | 0.993 ± 0.087              |
| AD gradients/pdf_ad_safe Gamma/Mooncake reverse       | 28.7 ± 11 μs      | 28.7 ± 11 μs      | 0.999 ± 0.54               |
| AD gradients/pdf_ad_safe Gamma/ReverseDiff (tape)     | 15.4 ± 0.55 μs    | 15.2 ± 0.51 μs    | 1.01 ± 0.049               |
| Baseline/Gamma/ccdf                                   | 3.74 ± 0.45 μs    | 3.75 ± 0.45 μs    | 0.998 ± 0.17               |
| Baseline/Gamma/cdf                                    | 3.75 ± 0.43 μs    | 3.75 ± 0.45 μs    | 0.998 ± 0.17               |
| Baseline/Gamma/logccdf                                | 5.96 ± 0.099 μs   | 5.89 ± 0.099 μs   | 1.01 ± 0.024               |
| Baseline/Gamma/logcdf                                 | 5.65 ± 0.088 μs   | 5.66 ± 0.089 μs   | 0.999 ± 0.022              |
| Baseline/Gamma/pdf                                    | 3.64 ± 0.43 μs    | 3.63 ± 0.44 μs    | 1 ± 0.17                   |
| Hooks/Gamma/ccdf_ad_safe                              | 3.8 ± 0.43 μs     | 3.9 ± 0.44 μs     | 0.974 ± 0.16               |
| Hooks/Gamma/cdf_ad_safe                               | 3.74 ± 0.42 μs    | 3.85 ± 0.42 μs    | 0.972 ± 0.15               |
| Hooks/Gamma/logccdf_ad_safe                           | 5.83 ± 0.082 μs   | 5.95 ± 0.074 μs   | 0.98 ± 0.018               |
| Hooks/Gamma/logcdf_ad_safe                            | 5.41 ± 0.075 μs   | 5.59 ± 0.073 μs   | 0.97 ± 0.019               |
| Hooks/Gamma/pdf_ad_safe                               | 3.64 ± 0.47 μs    | 3.63 ± 0.42 μs    | 1 ± 0.17                   |
| Hooks/Normal (fall-through)/cdf_ad_safe               | 1.64 ± 0.36 μs    | 1.63 ± 0.37 μs    | 1.01 ± 0.32                |
| Hooks/Normal (fall-through)/logcdf_ad_safe            | 4.11 ± 0.26 μs    | 4.12 ± 0.26 μs    | 0.999 ± 0.088              |
| Hooks/Normal (fall-through)/pdf_ad_safe               | 1.1 ± 0.39 μs     | 1.1 ± 0.39 μs     | 0.995 ± 0.5                |
| Hooks/_gamma_cdf/broadcast                            | 3.76 ± 0.45 μs    | 3.75 ± 0.45 μs    | 1 ± 0.17                   |
| Hooks/_gamma_cdf/scalar                               | 1.74 ± 0.01 ns    | 1.74 ± 0.01 ns    | 1 ± 0.0081                 |
| time_to_load                                          | 0.516 ± 0.00012 s | 0.507 ± 0.0017 s  | 1.02 ± 0.0035              |

|                                                       | v0.1.0                    | fa90e6a4370adf...         | v0.1.0 / fa90e6a4370adf... |
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

