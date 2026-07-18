|                                                       | v0.1.0           | 0c4871893f9b30... | v0.1.0 / 0c4871893f9b30... |
|:------------------------------------------------------|:----------------:|:-----------------:|:--------------------------:|
| AD gradients/_gamma_cdf direct/Enzyme forward         | 7.51 ± 0.06 μs   | 7.5 ± 0.053 μs    | 1 ± 0.011                  |
| AD gradients/_gamma_cdf direct/Enzyme reverse         | 0.308 ± 0.018 μs | 0.307 ± 0.018 μs  | 1 ± 0.084                  |
| AD gradients/_gamma_cdf direct/ForwardDiff            | 0.763 ± 0.1 μs   | 0.752 ± 0.1 μs    | 1.01 ± 0.2                 |
| AD gradients/_gamma_cdf direct/Mooncake forward       | 6.13 ± 0.76 μs   | 6.11 ± 0.71 μs    | 1 ± 0.17                   |
| AD gradients/_gamma_cdf direct/Mooncake reverse       | 4.93 ± 0.33 μs   | 5.05 ± 0.35 μs    | 0.976 ± 0.094              |
| AD gradients/_gamma_cdf direct/ReverseDiff (tape)     | 0.97 ± 0.19 μs   | 0.944 ± 0.2 μs    | 1.03 ± 0.29                |
| AD gradients/ccdf_ad_safe Gamma/Enzyme forward        | 9.51 ± 0.08 μs   | 9.67 ± 0.09 μs    | 0.983 ± 0.012              |
| AD gradients/ccdf_ad_safe Gamma/Enzyme reverse        | 4.58 ± 0.073 μs  | 4.59 ± 0.057 μs   | 0.998 ± 0.02               |
| AD gradients/ccdf_ad_safe Gamma/ForwardDiff           | 1.54 ± 0.014 μs  | 1.51 ± 0.011 μs   | 1.02 ± 0.012               |
| AD gradients/ccdf_ad_safe Gamma/Mooncake forward      | 7.84 ± 0.13 μs   | 7.75 ± 0.14 μs    | 1.01 ± 0.025               |
| AD gradients/ccdf_ad_safe Gamma/Mooncake reverse      | 22.1 ± 8.9 μs    | 21.6 ± 8.7 μs     | 1.02 ± 0.58                |
| AD gradients/ccdf_ad_safe Gamma/ReverseDiff (tape)    | 6.49 ± 0.23 μs   | 6.45 ± 0.2 μs     | 1.01 ± 0.047               |
| AD gradients/cdf_ad_safe Gamma/Enzyme forward         | 9.54 ± 0.09 μs   | 9.61 ± 0.1 μs     | 0.993 ± 0.014              |
| AD gradients/cdf_ad_safe Gamma/Enzyme reverse         | 4.57 ± 0.07 μs   | 4.56 ± 0.052 μs   | 1 ± 0.019                  |
| AD gradients/cdf_ad_safe Gamma/ForwardDiff            | 1.51 ± 0.013 μs  | 1.5 ± 0.011 μs    | 1 ± 0.011                  |
| AD gradients/cdf_ad_safe Gamma/Mooncake forward       | 7.81 ± 0.14 μs   | 7.63 ± 0.13 μs    | 1.02 ± 0.025               |
| AD gradients/cdf_ad_safe Gamma/Mooncake reverse       | 22.2 ± 9 μs      | 21.8 ± 9 μs       | 1.02 ± 0.59                |
| AD gradients/cdf_ad_safe Gamma/ReverseDiff (tape)     | 4.73 ± 0.09 μs   | 4.69 ± 0.08 μs    | 1.01 ± 0.026               |
| AD gradients/logccdf_ad_safe Gamma/Enzyme forward     | 9.58 ± 0.089 μs  | 9.66 ± 0.09 μs    | 0.992 ± 0.013              |
| AD gradients/logccdf_ad_safe Gamma/Enzyme reverse     | 4.69 ± 0.07 μs   | 4.71 ± 0.052 μs   | 0.996 ± 0.018              |
| AD gradients/logccdf_ad_safe Gamma/ForwardDiff        | 1.54 ± 0.013 μs  | 1.55 ± 0.012 μs   | 0.994 ± 0.011              |
| AD gradients/logccdf_ad_safe Gamma/Mooncake forward   | 8.17 ± 0.16 μs   | 8 ± 0.15 μs       | 1.02 ± 0.028               |
| AD gradients/logccdf_ad_safe Gamma/Mooncake reverse   | 22.6 ± 9.3 μs    | 22 ± 9 μs         | 1.03 ± 0.6                 |
| AD gradients/logccdf_ad_safe Gamma/ReverseDiff (tape) | 5.5 ± 0.92 μs    | 5.33 ± 0.93 μs    | 1.03 ± 0.25                |
| AD gradients/logcdf_ad_safe Gamma/Enzyme forward      | 9.66 ± 0.1 μs    | 9.7 ± 0.09 μs     | 0.996 ± 0.014              |
| AD gradients/logcdf_ad_safe Gamma/Enzyme reverse      | 4.68 ± 0.064 μs  | 4.72 ± 0.057 μs   | 0.993 ± 0.018              |
| AD gradients/logcdf_ad_safe Gamma/ForwardDiff         | 1.56 ± 0.013 μs  | 1.6 ± 0.011 μs    | 0.973 ± 0.01               |
| AD gradients/logcdf_ad_safe Gamma/Mooncake forward    | 8.01 ± 0.15 μs   | 8 ± 0.13 μs       | 1 ± 0.025                  |
| AD gradients/logcdf_ad_safe Gamma/Mooncake reverse    | 22.2 ± 9.1 μs    | 22.1 ± 9 μs       | 1 ± 0.58                   |
| AD gradients/logcdf_ad_safe Gamma/ReverseDiff (tape)  | 5.22 ± 0.78 μs   | 5.11 ± 0.39 μs    | 1.02 ± 0.17                |
| AD gradients/pdf_ad_safe Gamma/Enzyme forward         | 8.41 ± 0.067 μs  | 8.52 ± 0.064 μs   | 0.988 ± 0.011              |
| AD gradients/pdf_ad_safe Gamma/Enzyme reverse         | 3.56 ± 0.052 μs  | 3.55 ± 0.052 μs   | 1 ± 0.021                  |
| AD gradients/pdf_ad_safe Gamma/ForwardDiff            | 0.836 ± 0.085 μs | 0.765 ± 0.091 μs  | 1.09 ± 0.17                |
| AD gradients/pdf_ad_safe Gamma/Mooncake forward       | 6.26 ± 0.29 μs   | 6.17 ± 0.29 μs    | 1.01 ± 0.067               |
| AD gradients/pdf_ad_safe Gamma/Mooncake reverse       | 27.4 ± 11 μs     | 27.8 ± 12 μs      | 0.984 ± 0.57               |
| AD gradients/pdf_ad_safe Gamma/ReverseDiff (tape)     | 16.7 ± 0.35 μs   | 14.9 ± 0.34 μs    | 1.12 ± 0.035               |
| Baseline/Gamma/ccdf                                   | 3.58 ± 0.36 μs   | 3.56 ± 0.38 μs    | 1.01 ± 0.15                |
| Baseline/Gamma/cdf                                    | 3.58 ± 0.37 μs   | 3.57 ± 0.39 μs    | 1 ± 0.15                   |
| Baseline/Gamma/logccdf                                | 5.72 ± 0.07 μs   | 5.66 ± 0.038 μs   | 1.01 ± 0.014               |
| Baseline/Gamma/logcdf                                 | 5.59 ± 0.059 μs  | 5.55 ± 0.047 μs   | 1.01 ± 0.014               |
| Baseline/Gamma/pdf                                    | 4.29 ± 0.21 μs   | 4.16 ± 0.21 μs    | 1.03 ± 0.073               |
| Hooks/Gamma/ccdf_ad_safe                              | 3.61 ± 0.36 μs   | 3.64 ± 0.37 μs    | 0.991 ± 0.14               |
| Hooks/Gamma/cdf_ad_safe                               | 3.57 ± 0.37 μs   | 3.55 ± 0.38 μs    | 1.01 ± 0.15                |
| Hooks/Gamma/logccdf_ad_safe                           | 5.31 ± 0.052 μs  | 5.35 ± 0.058 μs   | 0.992 ± 0.015              |
| Hooks/Gamma/logcdf_ad_safe                            | 4.94 ± 0.22 μs   | 4.94 ± 0.21 μs    | 1 ± 0.063                  |
| Hooks/Gamma/pdf_ad_safe                               | 4.3 ± 0.21 μs    | 4.17 ± 0.21 μs    | 1.03 ± 0.073               |
| Hooks/Normal (fall-through)/cdf_ad_safe               | 1.49 ± 0.3 μs    | 1.47 ± 0.32 μs    | 1.01 ± 0.3                 |
| Hooks/Normal (fall-through)/logcdf_ad_safe            | 3.97 ± 0.36 μs   | 3.94 ± 0.36 μs    | 1.01 ± 0.13                |
| Hooks/Normal (fall-through)/pdf_ad_safe               | 1.08 ± 0.34 μs   | 1.08 ± 0.34 μs    | 0.996 ± 0.44               |
| Hooks/_gamma_cdf/broadcast                            | 3.57 ± 0.38 μs   | 3.57 ± 0.38 μs    | 0.999 ± 0.15               |
| Hooks/_gamma_cdf/scalar                               | 1.55 ± 0.01 ns   | 1.55 ± 0.01 ns    | 1 ± 0.0091                 |
| time_to_load                                          | 0.487 ± 0.0061 s | 0.487 ± 0.003 s   | 1 ± 0.014                  |

|                                                       | v0.1.0                    | 0c4871893f9b30...         | v0.1.0 / 0c4871893f9b30... |
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

