|                                                       | v0.1.0           | 2b7ea57f887afc... | v0.1.0 / 2b7ea57f887afc... |
|:------------------------------------------------------|:----------------:|:-----------------:|:--------------------------:|
| AD gradients/_gamma_cdf direct/Enzyme forward         | 7.58 ± 0.083 μs  | 7.6 ± 0.075 μs    | 0.997 ± 0.015              |
| AD gradients/_gamma_cdf direct/Enzyme reverse         | 0.304 ± 0.019 μs | 0.305 ± 0.018 μs  | 0.999 ± 0.085              |
| AD gradients/_gamma_cdf direct/ForwardDiff            | 0.752 ± 0.095 μs | 0.767 ± 0.1 μs    | 0.98 ± 0.18                |
| AD gradients/_gamma_cdf direct/Mooncake forward       | 6.11 ± 0.84 μs   | 6.14 ± 0.73 μs    | 0.995 ± 0.18               |
| AD gradients/_gamma_cdf direct/Mooncake reverse       | 5.11 ± 0.47 μs   | 5.03 ± 0.36 μs    | 1.02 ± 0.12                |
| AD gradients/_gamma_cdf direct/ReverseDiff (tape)     | 0.863 ± 0.19 μs  | 0.973 ± 0.2 μs    | 0.887 ± 0.26               |
| AD gradients/ccdf_ad_safe Gamma/Enzyme forward        | 9.62 ± 0.09 μs   | 9.58 ± 0.1 μs     | 1 ± 0.014                  |
| AD gradients/ccdf_ad_safe Gamma/Enzyme reverse        | 4.48 ± 0.072 μs  | 4.41 ± 0.063 μs   | 1.02 ± 0.022               |
| AD gradients/ccdf_ad_safe Gamma/ForwardDiff           | 1.52 ± 0.014 μs  | 1.5 ± 0.015 μs    | 1.01 ± 0.014               |
| AD gradients/ccdf_ad_safe Gamma/Mooncake forward      | 7.79 ± 0.18 μs   | 7.77 ± 0.14 μs    | 1 ± 0.029                  |
| AD gradients/ccdf_ad_safe Gamma/Mooncake reverse      | 22.3 ± 8.9 μs    | 21.9 ± 8.8 μs     | 1.02 ± 0.58                |
| AD gradients/ccdf_ad_safe Gamma/ReverseDiff (tape)    | 6.59 ± 0.22 μs   | 6.44 ± 0.19 μs    | 1.02 ± 0.046               |
| AD gradients/cdf_ad_safe Gamma/Enzyme forward         | 9.53 ± 0.08 μs   | 9.54 ± 0.089 μs   | 0.999 ± 0.013              |
| AD gradients/cdf_ad_safe Gamma/Enzyme reverse         | 4.4 ± 0.072 μs   | 4.4 ± 0.064 μs    | 1 ± 0.022                  |
| AD gradients/cdf_ad_safe Gamma/ForwardDiff            | 1.52 ± 0.013 μs  | 1.49 ± 0.013 μs   | 1.02 ± 0.013               |
| AD gradients/cdf_ad_safe Gamma/Mooncake forward       | 7.78 ± 0.17 μs   | 7.72 ± 0.15 μs    | 1.01 ± 0.03                |
| AD gradients/cdf_ad_safe Gamma/Mooncake reverse       | 22.4 ± 9 μs      | 21.9 ± 8.8 μs     | 1.02 ± 0.58                |
| AD gradients/cdf_ad_safe Gamma/ReverseDiff (tape)     | 4.78 ± 0.094 μs  | 4.7 ± 0.092 μs    | 1.02 ± 0.028               |
| AD gradients/logccdf_ad_safe Gamma/Enzyme forward     | 9.65 ± 0.1 μs    | 9.62 ± 0.1 μs     | 1 ± 0.015                  |
| AD gradients/logccdf_ad_safe Gamma/Enzyme reverse     | 4.63 ± 0.077 μs  | 4.62 ± 0.063 μs   | 1 ± 0.022                  |
| AD gradients/logccdf_ad_safe Gamma/ForwardDiff        | 1.56 ± 0.016 μs  | 1.55 ± 0.012 μs   | 1.01 ± 0.013               |
| AD gradients/logccdf_ad_safe Gamma/Mooncake forward   | 8.05 ± 0.17 μs   | 8.01 ± 0.15 μs    | 1.01 ± 0.028               |
| AD gradients/logccdf_ad_safe Gamma/Mooncake reverse   | 22.6 ± 8.7 μs    | 22.5 ± 9 μs       | 1.01 ± 0.56                |
| AD gradients/logccdf_ad_safe Gamma/ReverseDiff (tape) | 5.41 ± 0.88 μs   | 5.32 ± 0.87 μs    | 1.02 ± 0.24                |
| AD gradients/logcdf_ad_safe Gamma/Enzyme forward      | 9.6 ± 0.091 μs   | 9.55 ± 0.09 μs    | 1.01 ± 0.013               |
| AD gradients/logcdf_ad_safe Gamma/Enzyme reverse      | 4.53 ± 0.074 μs  | 4.52 ± 0.061 μs   | 1 ± 0.021                  |
| AD gradients/logcdf_ad_safe Gamma/ForwardDiff         | 1.53 ± 0.014 μs  | 1.53 ± 0.012 μs   | 1 ± 0.012                  |
| AD gradients/logcdf_ad_safe Gamma/Mooncake forward    | 7.99 ± 0.17 μs   | 8.06 ± 0.16 μs    | 0.991 ± 0.029              |
| AD gradients/logcdf_ad_safe Gamma/Mooncake reverse    | 22.4 ± 9 μs      | 22.6 ± 8.9 μs     | 0.991 ± 0.56               |
| AD gradients/logcdf_ad_safe Gamma/ReverseDiff (tape)  | 5.15 ± 0.38 μs   | 5.09 ± 0.79 μs    | 1.01 ± 0.17                |
| AD gradients/pdf_ad_safe Gamma/Enzyme forward         | 8.39 ± 0.073 μs  | 8.39 ± 0.08 μs    | 1 ± 0.013                  |
| AD gradients/pdf_ad_safe Gamma/Enzyme reverse         | 3.43 ± 0.075 μs  | 3.39 ± 0.056 μs   | 1.01 ± 0.028               |
| AD gradients/pdf_ad_safe Gamma/ForwardDiff            | 0.942 ± 0.092 μs | 0.834 ± 0.089 μs  | 1.13 ± 0.16                |
| AD gradients/pdf_ad_safe Gamma/Mooncake forward       | 6.3 ± 0.4 μs     | 6.26 ± 0.33 μs    | 1.01 ± 0.083               |
| AD gradients/pdf_ad_safe Gamma/Mooncake reverse       | 28 ± 11 μs       | 27.5 ± 11 μs      | 1.02 ± 0.56                |
| AD gradients/pdf_ad_safe Gamma/ReverseDiff (tape)     | 15.2 ± 0.39 μs   | 15.3 ± 0.37 μs    | 0.998 ± 0.035              |
| Baseline/Gamma/ccdf                                   | 3.57 ± 0.37 μs   | 3.59 ± 0.37 μs    | 0.994 ± 0.15               |
| Baseline/Gamma/cdf                                    | 3.58 ± 0.38 μs   | 3.59 ± 0.37 μs    | 0.999 ± 0.15               |
| Baseline/Gamma/logccdf                                | 5.67 ± 0.064 μs  | 5.7 ± 0.05 μs     | 0.995 ± 0.014              |
| Baseline/Gamma/logcdf                                 | 5.61 ± 0.069 μs  | 5.54 ± 0.053 μs   | 1.01 ± 0.016               |
| Baseline/Gamma/pdf                                    | 4.31 ± 0.21 μs   | 4.17 ± 0.21 μs    | 1.03 ± 0.073               |
| Hooks/Gamma/ccdf_ad_safe                              | 3.63 ± 0.37 μs   | 3.67 ± 0.35 μs    | 0.989 ± 0.14               |
| Hooks/Gamma/cdf_ad_safe                               | 3.57 ± 0.37 μs   | 3.58 ± 0.37 μs    | 0.998 ± 0.14               |
| Hooks/Gamma/logccdf_ad_safe                           | 5.36 ± 0.062 μs  | 5.3 ± 0.06 μs     | 1.01 ± 0.016               |
| Hooks/Gamma/logcdf_ad_safe                            | 4.96 ± 0.21 μs   | 4.98 ± 0.22 μs    | 0.995 ± 0.061              |
| Hooks/Gamma/pdf_ad_safe                               | 4.29 ± 0.21 μs   | 4.18 ± 0.21 μs    | 1.03 ± 0.072               |
| Hooks/Normal (fall-through)/cdf_ad_safe               | 1.48 ± 0.3 μs    | 1.52 ± 0.31 μs    | 0.973 ± 0.28               |
| Hooks/Normal (fall-through)/logcdf_ad_safe            | 3.94 ± 0.35 μs   | 3.93 ± 0.35 μs    | 1 ± 0.12                   |
| Hooks/Normal (fall-through)/pdf_ad_safe               | 1.08 ± 0.33 μs   | 1.09 ± 0.33 μs    | 0.993 ± 0.43               |
| Hooks/_gamma_cdf/broadcast                            | 3.61 ± 0.36 μs   | 3.59 ± 0.37 μs    | 1.01 ± 0.14                |
| Hooks/_gamma_cdf/scalar                               | 2.46 ± 0.91 ns   | 2.48 ± 0.001 ns   | 0.996 ± 0.37               |
| time_to_load                                          | 0.512 ± 0.0067 s | 0.508 ± 0.02 s    | 1.01 ± 0.042               |

|                                                       | v0.1.0                    | 2b7ea57f887afc...         | v0.1.0 / 2b7ea57f887afc... |
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

