|                                                       | v0.1.0           | d5ba779f3a84df... | v0.1.0 / d5ba779f3a84df... |
|:------------------------------------------------------|:----------------:|:-----------------:|:--------------------------:|
| AD gradients/_gamma_cdf direct/Enzyme forward         | 7.13 ± 0.14 μs   | 7.11 ± 0.11 μs    | 1 ± 0.025                  |
| AD gradients/_gamma_cdf direct/Enzyme reverse         | 0.308 ± 0.021 μs | 0.307 ± 0.022 μs  | 1 ± 0.097                  |
| AD gradients/_gamma_cdf direct/ForwardDiff            | 0.797 ± 0.12 μs  | 0.792 ± 0.13 μs   | 1.01 ± 0.22                |
| AD gradients/_gamma_cdf direct/Mooncake forward       | 6.39 ± 0.41 μs   | 6.29 ± 0.36 μs    | 1.02 ± 0.087               |
| AD gradients/_gamma_cdf direct/Mooncake reverse       | 5.32 ± 0.24 μs   | 5.22 ± 0.22 μs    | 1.02 ± 0.063               |
| AD gradients/_gamma_cdf direct/ReverseDiff (tape)     | 0.923 ± 0.23 μs  | 0.974 ± 0.23 μs   | 0.948 ± 0.32               |
| AD gradients/ccdf_ad_safe Gamma/Enzyme forward        | 9.02 ± 0.16 μs   | 9.01 ± 0.15 μs    | 1 ± 0.024                  |
| AD gradients/ccdf_ad_safe Gamma/Enzyme reverse        | 4.59 ± 0.11 μs   | 4.56 ± 0.11 μs    | 1.01 ± 0.034               |
| AD gradients/ccdf_ad_safe Gamma/ForwardDiff           | 1.58 ± 0.028 μs  | 1.56 ± 0.026 μs   | 1.01 ± 0.025               |
| AD gradients/ccdf_ad_safe Gamma/Mooncake forward      | 8.14 ± 0.25 μs   | 8.19 ± 0.19 μs    | 0.993 ± 0.038              |
| AD gradients/ccdf_ad_safe Gamma/Mooncake reverse      | 23.2 ± 8.8 μs    | 22.8 ± 9 μs       | 1.02 ± 0.56                |
| AD gradients/ccdf_ad_safe Gamma/ReverseDiff (tape)    | 6.48 ± 0.33 μs   | 6.51 ± 0.3 μs     | 0.995 ± 0.068              |
| AD gradients/cdf_ad_safe Gamma/Enzyme forward         | 9.02 ± 0.14 μs   | 9 ± 0.13 μs       | 1 ± 0.022                  |
| AD gradients/cdf_ad_safe Gamma/Enzyme reverse         | 4.57 ± 0.11 μs   | 4.59 ± 0.11 μs    | 0.996 ± 0.034              |
| AD gradients/cdf_ad_safe Gamma/ForwardDiff            | 1.56 ± 0.026 μs  | 1.56 ± 0.025 μs   | 1.01 ± 0.023               |
| AD gradients/cdf_ad_safe Gamma/Mooncake forward       | 8.07 ± 0.22 μs   | 8.04 ± 0.21 μs    | 1 ± 0.038                  |
| AD gradients/cdf_ad_safe Gamma/Mooncake reverse       | 23 ± 8.9 μs      | 22.8 ± 9 μs       | 1.01 ± 0.56                |
| AD gradients/cdf_ad_safe Gamma/ReverseDiff (tape)     | 4.55 ± 0.14 μs   | 4.59 ± 0.12 μs    | 0.992 ± 0.04               |
| AD gradients/logccdf_ad_safe Gamma/Enzyme forward     | 9.07 ± 0.19 μs   | 9.07 ± 0.14 μs    | 1 ± 0.026                  |
| AD gradients/logccdf_ad_safe Gamma/Enzyme reverse     | 4.76 ± 0.12 μs   | 4.83 ± 0.14 μs    | 0.986 ± 0.038              |
| AD gradients/logccdf_ad_safe Gamma/ForwardDiff        | 1.58 ± 0.028 μs  | 1.59 ± 0.024 μs   | 0.992 ± 0.023              |
| AD gradients/logccdf_ad_safe Gamma/Mooncake forward   | 8.39 ± 0.23 μs   | 8.41 ± 0.21 μs    | 0.997 ± 0.037              |
| AD gradients/logccdf_ad_safe Gamma/Mooncake reverse   | 23.2 ± 9 μs      | 23.2 ± 9 μs       | 0.996 ± 0.54               |
| AD gradients/logccdf_ad_safe Gamma/ReverseDiff (tape) | 5.29 ± 1.1 μs    | 5.3 ± 1.1 μs      | 0.997 ± 0.29               |
| AD gradients/logcdf_ad_safe Gamma/Enzyme forward      | 9.06 ± 0.15 μs   | 9.07 ± 0.14 μs    | 0.999 ± 0.022              |
| AD gradients/logcdf_ad_safe Gamma/Enzyme reverse      | 4.71 ± 0.11 μs   | 4.76 ± 0.1 μs     | 0.989 ± 0.032              |
| AD gradients/logcdf_ad_safe Gamma/ForwardDiff         | 1.62 ± 0.027 μs  | 1.58 ± 0.026 μs   | 1.03 ± 0.024               |
| AD gradients/logcdf_ad_safe Gamma/Mooncake forward    | 8.32 ± 0.22 μs   | 8.28 ± 0.21 μs    | 1 ± 0.037                  |
| AD gradients/logcdf_ad_safe Gamma/Mooncake reverse    | 23.1 ± 8.5 μs    | 23 ± 8.9 μs       | 1 ± 0.54                   |
| AD gradients/logcdf_ad_safe Gamma/ReverseDiff (tape)  | 5.01 ± 0.98 μs   | 5.02 ± 0.99 μs    | 0.999 ± 0.28               |
| AD gradients/pdf_ad_safe Gamma/Enzyme forward         | 7.97 ± 0.14 μs   | 7.92 ± 0.13 μs    | 1.01 ± 0.024               |
| AD gradients/pdf_ad_safe Gamma/Enzyme reverse         | 3.5 ± 0.095 μs   | 3.52 ± 0.086 μs   | 0.992 ± 0.036              |
| AD gradients/pdf_ad_safe Gamma/ForwardDiff            | 0.868 ± 0.11 μs  | 0.87 ± 0.11 μs    | 0.998 ± 0.18               |
| AD gradients/pdf_ad_safe Gamma/Mooncake forward       | 6.62 ± 0.37 μs   | 6.54 ± 0.4 μs     | 1.01 ± 0.084               |
| AD gradients/pdf_ad_safe Gamma/Mooncake reverse       | 28.6 ± 11 μs     | 29 ± 11 μs        | 0.988 ± 0.54               |
| AD gradients/pdf_ad_safe Gamma/ReverseDiff (tape)     | 15.5 ± 0.6 μs    | 15.5 ± 0.51 μs    | 1 ± 0.051                  |
| Baseline/Gamma/ccdf                                   | 3.83 ± 0.44 μs   | 3.83 ± 0.44 μs    | 1 ± 0.16                   |
| Baseline/Gamma/cdf                                    | 3.83 ± 0.44 μs   | 3.83 ± 0.44 μs    | 1 ± 0.16                   |
| Baseline/Gamma/logccdf                                | 5.92 ± 0.093 μs  | 5.89 ± 0.14 μs    | 1.01 ± 0.029               |
| Baseline/Gamma/logcdf                                 | 5.65 ± 0.09 μs   | 5.66 ± 0.087 μs   | 0.998 ± 0.022              |
| Baseline/Gamma/pdf                                    | 3.64 ± 0.44 μs   | 3.63 ± 0.44 μs    | 1 ± 0.17                   |
| Hooks/Gamma/ccdf_ad_safe                              | 3.93 ± 0.44 μs   | 3.86 ± 0.43 μs    | 1.02 ± 0.16                |
| Hooks/Gamma/cdf_ad_safe                               | 3.85 ± 0.43 μs   | 3.85 ± 0.42 μs    | 1 ± 0.16                   |
| Hooks/Gamma/logccdf_ad_safe                           | 5.83 ± 0.14 μs   | 5.8 ± 0.074 μs    | 1 ± 0.027                  |
| Hooks/Gamma/logcdf_ad_safe                            | 5.44 ± 0.084 μs  | 5.42 ± 0.072 μs   | 1 ± 0.02                   |
| Hooks/Gamma/pdf_ad_safe                               | 3.64 ± 0.43 μs   | 3.63 ± 0.43 μs    | 1 ± 0.17                   |
| Hooks/Normal (fall-through)/cdf_ad_safe               | 1.65 ± 0.38 μs   | 1.61 ± 0.38 μs    | 1.02 ± 0.34                |
| Hooks/Normal (fall-through)/logcdf_ad_safe            | 4.11 ± 0.26 μs   | 4.12 ± 0.25 μs    | 0.998 ± 0.087              |
| Hooks/Normal (fall-through)/pdf_ad_safe               | 1.1 ± 0.39 μs    | 1.1 ± 0.39 μs     | 1 ± 0.5                    |
| Hooks/_gamma_cdf/broadcast                            | 3.76 ± 0.45 μs   | 3.75 ± 0.44 μs    | 1 ± 0.17                   |
| Hooks/_gamma_cdf/scalar                               | 1.74 ± 0.01 ns   | 1.74 ± 0.01 ns    | 1 ± 0.0081                 |
| time_to_load                                          | 0.54 ± 0.009 s   | 0.51 ± 0.004 s    | 1.06 ± 0.019               |

|                                                       | v0.1.0                    | d5ba779f3a84df...         | v0.1.0 / d5ba779f3a84df... |
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

