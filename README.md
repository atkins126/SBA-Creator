
# **vHDL Obfuscator GUI - Ofuscador de código HDL**
- - - 
![](https://sites.google.com/site/mikroelectronica/vhdl-obfuscator/icono.png)

Autor: Risco-Castillo, Miguel  
[GRUPO DE MICROELECTRÓNICA](http://ue.accesus.com "http://ue.accesus.com")  
Lima – Perú  

Los Lenguajes VHDL ([Very High Speed Integrated Circuit] Hardware Description Language) y Verilog HDL. son estándares definidos por la IEEE que permiten describir el comportamiento de hardware. Su aplicación más extendida, pero no única, es la generación de circuitos digitales y su simulación.

En algunas ocasiones un diseñador necesita compartir información pero no desea revelar el contenido de su código. Existen técnicas propietarias y seguras de los fabricantes de dispositivos lógicos programables (como las FPGA) que permiten encriptar el código, pero la mayor parte de las herramientas que realizan dicha protección, requieren de la adquisición de licencias adicionales y además no suelen ser portables.

Cuando lo que se desea es proteger en cierta medida la propiedad intelectual del código fuente HDL pero no necesariamente controlar la distribución del mismo es posible utilizar técnicas más sencillas como la ofuscación. Esto permite generar un archivo fuente en HDL que es muy difícil de ser leído por un ser humano pero sin embargo permanece válido y es aceptado por un sintetizador o compilador, generando un resultado funcionalmente idéntico al código original sin ofuscar. 

Hay que notar sin embargo, que la ofuscación no tiene por fin la protección de secretos industriales, sólo es una forma de ocultar información, haciendo que la lectura del código sea algo difícil y permitiendo la distribución libre del mismo entre plataformas de distintos fabricantes.

Este proyecto consiste en la generación de una herramienta con interfaz de usuario gráfico que permite ofuscar con facilidad código fuente HDL, permitiendo realizar comprobaciones de la sintaxis tanto mediante el resaltado de palabras clave como con el uso de una herramienta gratuita para la comprobación semántica.

La aplicación usa herramientas de los proyectos: 

+ [GHDL](https://sourceforge.net/projects/ghdl-updates)  
+ [HDLObf](https://sourceforge.net/projects/hdlobf/)  
+ [iCarus Verilog](https://sourceforge.net/projects/iverilog/)  

Y fue desarrollada en Free Pascal mediante el IDE [Lazarus](http://www.lazarus-ide.org/).

**La aplicación puede descargarse desde [SourceForge](https://sourceforge.net/projects/vhdl-obfuscator/).**

# Capturas de pantalla
- - - 

[![](https://sites.google.com/site/mikroelectronica/vhdl-obfuscator/source.png)](https://sites.google.com/site/mikroelectronica/vhdl-obfuscator/source.png?attredirects=0)

[![](https://sites.google.com/site/mikroelectronica/vhdl-obfuscator/obfuscated.png)](https://sites.google.com/site/mikroelectronica/vhdl-obfuscator/obfuscated.png?attredirects=0)

Preliminary Verilog support:

[![Verilog Support](https://sites.google.com/site/mikroelectronica/vhdl-obfuscator/source_verilog.png)](https://sites.google.com/site/mikroelectronica/vhdl-obfuscator/source_verilog.png?attredirects=0)