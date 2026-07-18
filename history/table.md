|                                                       | v0.1.0           | 1dc6a818a993cf... | v0.1.0 / 1dc6a818a993cf... |
|:------------------------------------------------------|:----------------:|:-----------------:|:--------------------------:|
| AD gradients/_gamma_cdf direct/Enzyme forward         | 6.39 ± 0.35 μs   | 6.44 ± 0.35 μs    | 0.992 ± 0.077              |
| AD gradients/_gamma_cdf direct/Enzyme reverse         | 0.248 ± 0.019 μs | 0.252 ± 0.022 μs  | 0.984 ± 0.12               |
| AD gradients/_gamma_cdf direct/ForwardDiff            | 0.645 ± 0.075 μs | 0.648 ± 0.075 μs  | 0.995 ± 0.16               |
| AD gradients/_gamma_cdf direct/Mooncake forward       | 5.42 ± 0.63 μs   | 5.37 ± 0.63 μs    | 1.01 ± 0.17                |
| AD gradients/_gamma_cdf direct/Mooncake reverse       | 4.54 ± 0.38 μs   | 4.73 ± 0.29 μs    | 0.959 ± 0.099              |
| AD gradients/_gamma_cdf direct/ReverseDiff (tape)     | 0.85 ± 0.17 μs   | 0.843 ± 0.19 μs   | 1.01 ± 0.3                 |
| AD gradients/ccdf_ad_safe Gamma/Enzyme forward        | 7.98 ± 0.32 μs   | 8.14 ± 0.31 μs    | 0.98 ± 0.054               |
| AD gradients/ccdf_ad_safe Gamma/Enzyme reverse        | 3.91 ± 0.21 μs   | 4.01 ± 0.18 μs    | 0.976 ± 0.068              |
| AD gradients/ccdf_ad_safe Gamma/ForwardDiff           | 1.3 ± 0.061 μs   | 1.35 ± 0.026 μs   | 0.966 ± 0.049              |
| AD gradients/ccdf_ad_safe Gamma/Mooncake forward      | 6.59 ± 0.43 μs   | 6.83 ± 0.51 μs    | 0.965 ± 0.096              |
| AD gradients/ccdf_ad_safe Gamma/Mooncake reverse      | 18.3 ± 6.1 μs    | 18.7 ± 6.1 μs     | 0.979 ± 0.46               |
| AD gradients/ccdf_ad_safe Gamma/ReverseDiff (tape)    | 6.13 ± 0.66 μs   | 6.05 ± 0.63 μs    | 1.01 ± 0.15                |
| AD gradients/cdf_ad_safe Gamma/Enzyme forward         | 8.14 ± 0.45 μs   | 8.12 ± 0.48 μs    | 1 ± 0.081                  |
| AD gradients/cdf_ad_safe Gamma/Enzyme reverse         | 3.95 ± 0.21 μs   | 3.91 ± 0.18 μs    | 1.01 ± 0.071               |
| AD gradients/cdf_ad_safe Gamma/ForwardDiff            | 1.3 ± 0.071 μs   | 1.35 ± 0.041 μs   | 0.964 ± 0.06               |
| AD gradients/cdf_ad_safe Gamma/Mooncake forward       | 6.75 ± 0.57 μs   | 6.68 ± 0.43 μs    | 1.01 ± 0.11                |
| AD gradients/cdf_ad_safe Gamma/Mooncake reverse       | 18 ± 6.1 μs      | 18.5 ± 6 μs       | 0.977 ± 0.46               |
| AD gradients/cdf_ad_safe Gamma/ReverseDiff (tape)     | 4.35 ± 0.28 μs   | 4.39 ± 0.18 μs    | 0.989 ± 0.075              |
| AD gradients/logccdf_ad_safe Gamma/Enzyme forward     | 8.18 ± 0.46 μs   | 8.14 ± 0.47 μs    | 1.01 ± 0.08                |
| AD gradients/logccdf_ad_safe Gamma/Enzyme reverse     | 4.2 ± 0.19 μs    | 4.01 ± 0.15 μs    | 1.05 ± 0.062               |
| AD gradients/logccdf_ad_safe Gamma/ForwardDiff        | 1.33 ± 0.048 μs  | 1.28 ± 0.06 μs    | 1.04 ± 0.061               |
| AD gradients/logccdf_ad_safe Gamma/Mooncake forward   | 6.92 ± 0.44 μs   | 6.88 ± 0.46 μs    | 1.01 ± 0.092               |
| AD gradients/logccdf_ad_safe Gamma/Mooncake reverse   | 18.9 ± 6.3 μs    | 18.8 ± 6 μs       | 1 ± 0.46                   |
| AD gradients/logccdf_ad_safe Gamma/ReverseDiff (tape) | 5.16 ± 0.72 μs   | 5.05 ± 0.79 μs    | 1.02 ± 0.21                |
| AD gradients/logcdf_ad_safe Gamma/Enzyme forward      | 8.22 ± 0.34 μs   | 8.1 ± 0.41 μs     | 1.02 ± 0.066               |
| AD gradients/logcdf_ad_safe Gamma/Enzyme reverse      | 4.04 ± 0.22 μs   | 4.03 ± 0.19 μs    | 1 ± 0.072                  |
| AD gradients/logcdf_ad_safe Gamma/ForwardDiff         | 1.3 ± 0.074 μs   | 1.25 ± 0.044 μs   | 1.04 ± 0.069               |
| AD gradients/logcdf_ad_safe Gamma/Mooncake forward    | 6.96 ± 0.5 μs    | 6.95 ± 0.74 μs    | 1 ± 0.13                   |
| AD gradients/logcdf_ad_safe Gamma/Mooncake reverse    | 18.5 ± 6.4 μs    | 18.8 ± 6 μs       | 0.981 ± 0.46               |
| AD gradients/logcdf_ad_safe Gamma/ReverseDiff (tape)  | 4.7 ± 0.64 μs    | 4.8 ± 0.7 μs      | 0.98 ± 0.2                 |
| AD gradients/pdf_ad_safe Gamma/Enzyme forward         | 7.21 ± 0.29 μs   | 7.49 ± 0.091 μs   | 0.963 ± 0.041              |
| AD gradients/pdf_ad_safe Gamma/Enzyme reverse         | 3.12 ± 0.15 μs   | 3.17 ± 0.17 μs    | 0.983 ± 0.072              |
| AD gradients/pdf_ad_safe Gamma/ForwardDiff            | 0.654 ± 0.068 μs | 0.671 ± 0.058 μs  | 0.975 ± 0.13               |
| AD gradients/pdf_ad_safe Gamma/Mooncake forward       | 5.62 ± 0.54 μs   | 5.57 ± 0.68 μs    | 1.01 ± 0.16                |
| AD gradients/pdf_ad_safe Gamma/Mooncake reverse       | 23.6 ± 8.3 μs    | 23.8 ± 8 μs       | 0.993 ± 0.48               |
| AD gradients/pdf_ad_safe Gamma/ReverseDiff (tape)     | 14.4 ± 0.89 μs   | 14.9 ± 0.81 μs    | 0.968 ± 0.08               |
| Baseline/Gamma/ccdf                                   | 2.84 ± 0.28 μs   | 2.83 ± 0.28 μs    | 1 ± 0.14                   |
| Baseline/Gamma/cdf                                    | 2.85 ± 0.27 μs   | 2.83 ± 0.26 μs    | 1.01 ± 0.13                |
| Baseline/Gamma/logccdf                                | 4.91 ± 0.26 μs   | 4.95 ± 0.3 μs     | 0.992 ± 0.079              |
| Baseline/Gamma/logcdf                                 | 4.86 ± 0.28 μs   | 4.91 ± 0.23 μs    | 0.989 ± 0.074              |
| Baseline/Gamma/pdf                                    | 3.08 ± 0.27 μs   | 3.07 ± 0.24 μs    | 1 ± 0.12                   |
| Hooks/Gamma/ccdf_ad_safe                              | 2.88 ± 0.22 μs   | 2.9 ± 0.29 μs     | 0.992 ± 0.12               |
| Hooks/Gamma/cdf_ad_safe                               | 2.82 ± 0.22 μs   | 2.82 ± 0.22 μs    | 1 ± 0.11                   |
| Hooks/Gamma/logccdf_ad_safe                           | 4.92 ± 0.28 μs   | 4.76 ± 0.29 μs    | 1.03 ± 0.085               |
| Hooks/Gamma/logcdf_ad_safe                            | 4.55 ± 0.31 μs   | 4.54 ± 0.29 μs    | 1 ± 0.094                  |
| Hooks/Gamma/pdf_ad_safe                               | 3.01 ± 0.29 μs   | 2.97 ± 0.28 μs    | 1.01 ± 0.14                |
| Hooks/Normal (fall-through)/cdf_ad_safe               | 1.36 ± 0.21 μs   | 1.35 ± 0.25 μs    | 1.01 ± 0.24                |
| Hooks/Normal (fall-through)/logcdf_ad_safe            | 3.48 ± 0.22 μs   | 3.5 ± 0.27 μs     | 0.996 ± 0.099              |
| Hooks/Normal (fall-through)/pdf_ad_safe               | 0.825 ± 0.28 μs  | 0.833 ± 0.28 μs   | 0.991 ± 0.47               |
| Hooks/_gamma_cdf/broadcast                            | 2.79 ± 0.2 μs    | 2.8 ± 0.26 μs     | 0.997 ± 0.12               |
| Hooks/_gamma_cdf/scalar                               | 1.35 ± 0.007 ns  | 1.35 ± 0.046 ns   | 1 ± 0.035                  |
| time_to_load                                          | 0.495 ± 0.0058 s | 0.484 ± 0.0072 s  | 1.02 ± 0.019               |

|                                                       | v0.1.0                    | 1dc6a818a993cf...         | v0.1.0 / 1dc6a818a993cf... |
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

