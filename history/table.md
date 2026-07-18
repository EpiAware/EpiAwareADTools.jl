|                                                       | v0.1.0           | f9a8b4c6ee7c38... | v0.1.0 / f9a8b4c6ee7c38... |
|:------------------------------------------------------|:----------------:|:-----------------:|:--------------------------:|
| AD gradients/_gamma_cdf direct/Enzyme forward         | 7.55 ± 0.06 μs   | 7.59 ± 0.065 μs   | 0.994 ± 0.012              |
| AD gradients/_gamma_cdf direct/Enzyme reverse         | 0.309 ± 0.018 μs | 0.307 ± 0.018 μs  | 1.01 ± 0.083               |
| AD gradients/_gamma_cdf direct/ForwardDiff            | 0.751 ± 0.1 μs   | 0.808 ± 0.11 μs   | 0.93 ± 0.18                |
| AD gradients/_gamma_cdf direct/Mooncake forward       | 6.28 ± 0.33 μs   | 6.14 ± 0.37 μs    | 1.02 ± 0.082               |
| AD gradients/_gamma_cdf direct/Mooncake reverse       | 5.07 ± 0.37 μs   | 5.01 ± 0.41 μs    | 1.01 ± 0.11                |
| AD gradients/_gamma_cdf direct/ReverseDiff (tape)     | 0.862 ± 0.19 μs  | 0.893 ± 0.19 μs   | 0.965 ± 0.3                |
| AD gradients/ccdf_ad_safe Gamma/Enzyme forward        | 9.55 ± 0.1 μs    | 9.68 ± 0.11 μs    | 0.987 ± 0.015              |
| AD gradients/ccdf_ad_safe Gamma/Enzyme reverse        | 4.68 ± 0.057 μs  | 4.62 ± 0.062 μs   | 1.01 ± 0.018               |
| AD gradients/ccdf_ad_safe Gamma/ForwardDiff           | 1.53 ± 0.012 μs  | 1.52 ± 0.013 μs   | 1.01 ± 0.012               |
| AD gradients/ccdf_ad_safe Gamma/Mooncake forward      | 7.74 ± 0.13 μs   | 7.88 ± 0.17 μs    | 0.982 ± 0.027              |
| AD gradients/ccdf_ad_safe Gamma/Mooncake reverse      | 21.9 ± 8.9 μs    | 22.3 ± 9.1 μs     | 0.981 ± 0.56               |
| AD gradients/ccdf_ad_safe Gamma/ReverseDiff (tape)    | 6.65 ± 0.2 μs    | 6.5 ± 0.21 μs     | 1.02 ± 0.045               |
| AD gradients/cdf_ad_safe Gamma/Enzyme forward         | 9.52 ± 0.09 μs   | 9.73 ± 0.11 μs    | 0.978 ± 0.014              |
| AD gradients/cdf_ad_safe Gamma/Enzyme reverse         | 4.61 ± 0.059 μs  | 4.56 ± 0.061 μs   | 1.01 ± 0.019               |
| AD gradients/cdf_ad_safe Gamma/ForwardDiff            | 1.52 ± 0.013 μs  | 1.52 ± 0.015 μs   | 1 ± 0.013                  |
| AD gradients/cdf_ad_safe Gamma/Mooncake forward       | 7.72 ± 0.16 μs   | 7.81 ± 0.16 μs    | 0.988 ± 0.029              |
| AD gradients/cdf_ad_safe Gamma/Mooncake reverse       | 22 ± 9.1 μs      | 22.2 ± 9.1 μs     | 0.992 ± 0.58               |
| AD gradients/cdf_ad_safe Gamma/ReverseDiff (tape)     | 4.78 ± 0.082 μs  | 4.77 ± 0.088 μs   | 1 ± 0.025                  |
| AD gradients/logccdf_ad_safe Gamma/Enzyme forward     | 9.61 ± 0.1 μs    | 9.63 ± 0.11 μs    | 0.998 ± 0.016              |
| AD gradients/logccdf_ad_safe Gamma/Enzyme reverse     | 4.8 ± 0.057 μs   | 4.73 ± 0.056 μs   | 1.01 ± 0.017               |
| AD gradients/logccdf_ad_safe Gamma/ForwardDiff        | 1.59 ± 0.013 μs  | 1.54 ± 0.012 μs   | 1.03 ± 0.012               |
| AD gradients/logccdf_ad_safe Gamma/Mooncake forward   | 8 ± 0.15 μs      | 8.26 ± 0.19 μs    | 0.968 ± 0.029              |
| AD gradients/logccdf_ad_safe Gamma/Mooncake reverse   | 22.3 ± 9.1 μs    | 22.6 ± 9.2 μs     | 0.986 ± 0.57               |
| AD gradients/logccdf_ad_safe Gamma/ReverseDiff (tape) | 5.45 ± 0.95 μs   | 5.41 ± 0.96 μs    | 1.01 ± 0.25                |
| AD gradients/logcdf_ad_safe Gamma/Enzyme forward      | 9.58 ± 0.1 μs    | 9.68 ± 0.11 μs    | 0.99 ± 0.015               |
| AD gradients/logcdf_ad_safe Gamma/Enzyme reverse      | 4.78 ± 0.059 μs  | 4.76 ± 0.063 μs   | 1 ± 0.018                  |
| AD gradients/logcdf_ad_safe Gamma/ForwardDiff         | 1.54 ± 0.011 μs  | 1.54 ± 0.012 μs   | 1 ± 0.011                  |
| AD gradients/logcdf_ad_safe Gamma/Mooncake forward    | 7.93 ± 0.14 μs   | 8.31 ± 0.18 μs    | 0.954 ± 0.027              |
| AD gradients/logcdf_ad_safe Gamma/Mooncake reverse    | 22.3 ± 9.2 μs    | 22.4 ± 9.3 μs     | 0.997 ± 0.58               |
| AD gradients/logcdf_ad_safe Gamma/ReverseDiff (tape)  | 5.19 ± 0.45 μs   | 5.21 ± 0.41 μs    | 0.996 ± 0.12               |
| AD gradients/pdf_ad_safe Gamma/Enzyme forward         | 8.42 ± 0.067 μs  | 8.42 ± 0.074 μs   | 0.999 ± 0.012              |
| AD gradients/pdf_ad_safe Gamma/Enzyme reverse         | 3.59 ± 0.05 μs   | 3.59 ± 0.058 μs   | 1 ± 0.021                  |
| AD gradients/pdf_ad_safe Gamma/ForwardDiff            | 0.846 ± 0.091 μs | 0.834 ± 0.09 μs   | 1.01 ± 0.15                |
| AD gradients/pdf_ad_safe Gamma/Mooncake forward       | 6.18 ± 0.35 μs   | 6.22 ± 0.33 μs    | 0.993 ± 0.077              |
| AD gradients/pdf_ad_safe Gamma/Mooncake reverse       | 28 ± 11 μs       | 28.1 ± 11 μs      | 0.997 ± 0.58               |
| AD gradients/pdf_ad_safe Gamma/ReverseDiff (tape)     | 15.7 ± 0.33 μs   | 15.8 ± 0.37 μs    | 0.995 ± 0.031              |
| Baseline/Gamma/ccdf                                   | 3.56 ± 0.38 μs   | 3.57 ± 0.37 μs    | 0.995 ± 0.15               |
| Baseline/Gamma/cdf                                    | 3.55 ± 0.38 μs   | 3.57 ± 0.38 μs    | 0.996 ± 0.15               |
| Baseline/Gamma/logccdf                                | 5.69 ± 0.045 μs  | 5.66 ± 0.055 μs   | 1 ± 0.013                  |
| Baseline/Gamma/logcdf                                 | 5.52 ± 0.049 μs  | 5.54 ± 0.05 μs    | 0.997 ± 0.013              |
| Baseline/Gamma/pdf                                    | 4.19 ± 0.21 μs   | 4.18 ± 0.2 μs     | 1 ± 0.07                   |
| Hooks/Gamma/ccdf_ad_safe                              | 3.61 ± 0.38 μs   | 3.62 ± 0.37 μs    | 0.998 ± 0.15               |
| Hooks/Gamma/cdf_ad_safe                               | 3.57 ± 0.37 μs   | 3.57 ± 0.38 μs    | 1 ± 0.15                   |
| Hooks/Gamma/logccdf_ad_safe                           | 5.3 ± 0.062 μs   | 5.33 ± 0.059 μs   | 0.994 ± 0.016              |
| Hooks/Gamma/logcdf_ad_safe                            | 4.93 ± 0.22 μs   | 5.01 ± 0.21 μs    | 0.984 ± 0.061              |
| Hooks/Gamma/pdf_ad_safe                               | 4.18 ± 0.21 μs   | 4.17 ± 0.21 μs    | 1 ± 0.07                   |
| Hooks/Normal (fall-through)/cdf_ad_safe               | 1.51 ± 0.35 μs   | 1.49 ± 0.31 μs    | 1.02 ± 0.32                |
| Hooks/Normal (fall-through)/logcdf_ad_safe            | 3.92 ± 0.36 μs   | 3.93 ± 0.36 μs    | 0.999 ± 0.13               |
| Hooks/Normal (fall-through)/pdf_ad_safe               | 1.09 ± 0.34 μs   | 1.08 ± 0.34 μs    | 1 ± 0.44                   |
| Hooks/_gamma_cdf/broadcast                            | 3.58 ± 0.37 μs   | 3.58 ± 0.38 μs    | 1 ± 0.15                   |
| Hooks/_gamma_cdf/scalar                               | 1.55 ± 0.009 ns  | 1.55 ± 0.009 ns   | 1 ± 0.0082                 |
| time_to_load                                          | 0.485 ± 0.0018 s | 0.486 ± 0.0025 s  | 0.999 ± 0.0063             |

|                                                       | v0.1.0                    | f9a8b4c6ee7c38...         | v0.1.0 / f9a8b4c6ee7c38... |
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

