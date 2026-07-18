|                                                       | v0.1.0           | 4efe7536cd86c0... | v0.1.0 / 4efe7536cd86c0... |
|:------------------------------------------------------|:----------------:|:-----------------:|:--------------------------:|
| AD gradients/_gamma_cdf direct/Enzyme forward         | 7.59 ± 0.052 μs  | 7.52 ± 0.05 μs    | 1.01 ± 0.0097              |
| AD gradients/_gamma_cdf direct/Enzyme reverse         | 0.305 ± 0.018 μs | 0.306 ± 0.018 μs  | 0.999 ± 0.083              |
| AD gradients/_gamma_cdf direct/ForwardDiff            | 0.757 ± 0.1 μs   | 0.75 ± 0.069 μs   | 1.01 ± 0.17                |
| AD gradients/_gamma_cdf direct/Mooncake forward       | 6.05 ± 0.74 μs   | 6.1 ± 0.68 μs     | 0.991 ± 0.16               |
| AD gradients/_gamma_cdf direct/Mooncake reverse       | 5.04 ± 0.26 μs   | 5 ± 0.26 μs       | 1.01 ± 0.074               |
| AD gradients/_gamma_cdf direct/ReverseDiff (tape)     | 0.896 ± 0.18 μs  | 0.858 ± 0.18 μs   | 1.04 ± 0.31                |
| AD gradients/ccdf_ad_safe Gamma/Enzyme forward        | 9.49 ± 0.063 μs  | 9.45 ± 0.06 μs    | 1 ± 0.0093                 |
| AD gradients/ccdf_ad_safe Gamma/Enzyme reverse        | 4.43 ± 0.064 μs  | 4.43 ± 0.046 μs   | 1 ± 0.018                  |
| AD gradients/ccdf_ad_safe Gamma/ForwardDiff           | 1.51 ± 0.011 μs  | 1.52 ± 0.012 μs   | 0.993 ± 0.011              |
| AD gradients/ccdf_ad_safe Gamma/Mooncake forward      | 7.75 ± 0.52 μs   | 7.76 ± 0.12 μs    | 0.999 ± 0.069              |
| AD gradients/ccdf_ad_safe Gamma/Mooncake reverse      | 20.6 ± 8.4 μs    | 22 ± 8.8 μs       | 0.938 ± 0.54               |
| AD gradients/ccdf_ad_safe Gamma/ReverseDiff (tape)    | 6.54 ± 0.19 μs   | 6.52 ± 0.88 μs    | 1 ± 0.14                   |
| AD gradients/cdf_ad_safe Gamma/Enzyme forward         | 9.65 ± 0.081 μs  | 9.45 ± 0.067 μs   | 1.02 ± 0.011               |
| AD gradients/cdf_ad_safe Gamma/Enzyme reverse         | 4.4 ± 0.057 μs   | 4.43 ± 0.049 μs   | 0.993 ± 0.017              |
| AD gradients/cdf_ad_safe Gamma/ForwardDiff            | 1.5 ± 0.01 μs    | 1.52 ± 0.014 μs   | 0.991 ± 0.011              |
| AD gradients/cdf_ad_safe Gamma/Mooncake forward       | 7.67 ± 0.12 μs   | 7.69 ± 0.13 μs    | 0.998 ± 0.023              |
| AD gradients/cdf_ad_safe Gamma/Mooncake reverse       | 21.5 ± 8.5 μs    | 21.7 ± 8.6 μs     | 0.994 ± 0.56               |
| AD gradients/cdf_ad_safe Gamma/ReverseDiff (tape)     | 4.72 ± 0.082 μs  | 4.69 ± 0.076 μs   | 1.01 ± 0.024               |
| AD gradients/logccdf_ad_safe Gamma/Enzyme forward     | 9.58 ± 0.09 μs   | 9.54 ± 0.064 μs   | 1 ± 0.012                  |
| AD gradients/logccdf_ad_safe Gamma/Enzyme reverse     | 4.55 ± 0.052 μs  | 4.54 ± 0.049 μs   | 1 ± 0.016                  |
| AD gradients/logccdf_ad_safe Gamma/ForwardDiff        | 1.53 ± 0.01 μs   | 1.54 ± 0.011 μs   | 0.997 ± 0.0096             |
| AD gradients/logccdf_ad_safe Gamma/Mooncake forward   | 8.07 ± 0.11 μs   | 8.18 ± 0.13 μs    | 0.988 ± 0.021              |
| AD gradients/logccdf_ad_safe Gamma/Mooncake reverse   | 22.4 ± 9.1 μs    | 22.2 ± 8.9 μs     | 1.01 ± 0.58                |
| AD gradients/logccdf_ad_safe Gamma/ReverseDiff (tape) | 5.41 ± 0.89 μs   | 5.37 ± 1 μs       | 1.01 ± 0.26                |
| AD gradients/logcdf_ad_safe Gamma/Enzyme forward      | 8.82 ± 0.74 μs   | 9.54 ± 0.063 μs   | 0.925 ± 0.078              |
| AD gradients/logcdf_ad_safe Gamma/Enzyme reverse      | 4.49 ± 0.054 μs  | 4.58 ± 0.047 μs   | 0.982 ± 0.016              |
| AD gradients/logcdf_ad_safe Gamma/ForwardDiff         | 1.55 ± 0.12 μs   | 1.55 ± 0.011 μs   | 0.995 ± 0.078              |
| AD gradients/logcdf_ad_safe Gamma/Mooncake forward    | 7.95 ± 0.13 μs   | 7.99 ± 0.14 μs    | 0.995 ± 0.023              |
| AD gradients/logcdf_ad_safe Gamma/Mooncake reverse    | 21.9 ± 8.8 μs    | 22.2 ± 8.6 μs     | 0.984 ± 0.55               |
| AD gradients/logcdf_ad_safe Gamma/ReverseDiff (tape)  | 5.08 ± 0.92 μs   | 5.12 ± 0.79 μs    | 0.993 ± 0.24               |
| AD gradients/pdf_ad_safe Gamma/Enzyme forward         | 8.41 ± 0.058 μs  | 8.37 ± 0.053 μs   | 1.01 ± 0.0094              |
| AD gradients/pdf_ad_safe Gamma/Enzyme reverse         | 3.38 ± 0.054 μs  | 3.4 ± 0.044 μs    | 0.997 ± 0.02               |
| AD gradients/pdf_ad_safe Gamma/ForwardDiff            | 0.774 ± 0.078 μs | 0.842 ± 0.089 μs  | 0.919 ± 0.13               |
| AD gradients/pdf_ad_safe Gamma/Mooncake forward       | 6.19 ± 0.7 μs    | 6.2 ± 0.62 μs     | 0.999 ± 0.15               |
| AD gradients/pdf_ad_safe Gamma/Mooncake reverse       | 26.2 ± 11 μs     | 27.9 ± 11 μs      | 0.938 ± 0.53               |
| AD gradients/pdf_ad_safe Gamma/ReverseDiff (tape)     | 14.9 ± 1.2 μs    | 15.2 ± 0.33 μs    | 0.982 ± 0.083              |
| Baseline/Gamma/ccdf                                   | 3.57 ± 0.39 μs   | 3.55 ± 0.38 μs    | 1.01 ± 0.15                |
| Baseline/Gamma/cdf                                    | 3.57 ± 0.39 μs   | 3.55 ± 0.38 μs    | 1.01 ± 0.15                |
| Baseline/Gamma/logccdf                                | 5.71 ± 0.05 μs   | 5.68 ± 0.045 μs   | 1 ± 0.012                  |
| Baseline/Gamma/logcdf                                 | 5.55 ± 0.045 μs  | 5.55 ± 0.047 μs   | 1 ± 0.012                  |
| Baseline/Gamma/pdf                                    | 4.19 ± 0.22 μs   | 4.15 ± 0.37 μs    | 1.01 ± 0.1                 |
| Hooks/Gamma/ccdf_ad_safe                              | 3.62 ± 0.21 μs   | 3.61 ± 0.36 μs    | 1 ± 0.12                   |
| Hooks/Gamma/cdf_ad_safe                               | 3.58 ± 0.37 μs   | 3.55 ± 0.36 μs    | 1.01 ± 0.14                |
| Hooks/Gamma/logccdf_ad_safe                           | 5.31 ± 0.22 μs   | 5.33 ± 0.045 μs   | 0.996 ± 0.041              |
| Hooks/Gamma/logcdf_ad_safe                            | 4.91 ± 0.58 μs   | 4.92 ± 0.22 μs    | 0.996 ± 0.13               |
| Hooks/Gamma/pdf_ad_safe                               | 4.16 ± 0.34 μs   | 4.18 ± 0.35 μs    | 0.996 ± 0.12               |
| Hooks/Normal (fall-through)/cdf_ad_safe               | 1.48 ± 0.32 μs   | 1.48 ± 0.31 μs    | 0.998 ± 0.3                |
| Hooks/Normal (fall-through)/logcdf_ad_safe            | 3.95 ± 0.37 μs   | 3.96 ± 0.35 μs    | 0.997 ± 0.13               |
| Hooks/Normal (fall-through)/pdf_ad_safe               | 1.09 ± 0.35 μs   | 1.07 ± 0.34 μs    | 1.01 ± 0.45                |
| Hooks/_gamma_cdf/broadcast                            | 3.56 ± 0.2 μs    | 3.55 ± 0.37 μs    | 1 ± 0.12                   |
| Hooks/_gamma_cdf/scalar                               | 1.43 ± 0.12 ns   | 1.55 ± 0.01 ns    | 0.923 ± 0.077              |
| time_to_load                                          | 0.49 ± 0.0069 s  | 0.488 ± 0.0011 s  | 1 ± 0.014                  |

|                                                       | v0.1.0                    | 4efe7536cd86c0...         | v0.1.0 / 4efe7536cd86c0... |
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
| time_to_load                                          | 0.15 k allocs: 11.7 kB    | 0.149 k allocs: 11.1 kB   | 1.05                       |

