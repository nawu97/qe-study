# QE里的一些不常用的tag
## 如果已经有NC的赝势，它具有PBE的交换关联泛函，但我们需要的是LDA的交换关联泛函，此时可以利用`input_dft`来指定
## input_dft
```

input_dft	CHARACTER
Default:	read from pseudopotential files
Exchange-correlation functional: eg 'PBE', 'BLYP' etc
See Modules/funct.f90 for allowed values.
Overrides the value read from pseudopotential files.
Use with care and if you know what you are doing!
         
```
### 注意事项：参考官网手册，通过这个可以人为指定泛函类型，具体修改参考 Modules/funct.f90

## 如果想构造交换关联函数，可人为赋予比例,比如PBE和LDA的比例构成杂化泛函
## exx_fraction
```
exx_fraction	REAL
Default:	it depends on the specified functional
Fraction of EXX for hybrid functional calculations. In the case of
input_dft='PBE0', the default value is 0.25, while for input_dft='B3LYP'
the exx_fraction default value is 0.20
```
### 注意事项：具体杂化比例可参考文献以及Modules/funct.f90
