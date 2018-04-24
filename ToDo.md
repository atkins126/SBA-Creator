~~listo: Borrar log al abrir nuevo proyecto o entrar en editor o puede ser borrado
 al salir a la pestaÃ±a de sistema.~~

Para monitorear cambios en los archivos:
http://forum.codecall.net/topic/76318-monitor-a-folder-for-changes/

~~Listo: Arreglar las excepciones al validar el código del PRG (el programa se cierra si se presiona Cancel)~~

~~Listo: Corregir el autoupdate, sourceforge ya no es compatible~~

En la verificación de sintaxis para el caso de un archivo en el editor, cuando este es un testbench y la instanciación
no se ha hecho declarativamente (component) no precompila el archivo bajo prueba, por lo cual la verificación de 
sintaxis falla al no encontrar el componente (library work).

Cuando se hace doble click en un archivo asociado, debería de abrirse en una de las instancias ya abiertas de
SBACreator: http://stackoverflow.com/questions/8688078/preventing-multiple-instances-but-also-handle-the-command-line-parameters
Puede verse como lo hace lazarus.

Clasificar la sección user files, podría permitirse agregar carpetas para separar los vhd de los archivos de testbench,
archivos de restricciones para cada tipo de tarjeta, etc. La jerarquía de carpetas deben aparecer en el árbol del proyecto.

Si hay un proyecto abierto, la ruta por defecto para los nuevos archivos debe ser el directorio del proyecto.

Si se reinicia el editor PRG (nuevo controler) reiniciar también el nombre del archivo prg para que "save as" sea usado de nuevo y no se use el nombre del prg anterior. 

Para ampliar el funcionamiento del plugin de edición sincronizada se ha hecho un cambio a la unidad SynPluginSyncroEdit:
de  MAX_SYNC_ED_WORDS = 50// 250;  a  MAX_SYNC_ED_WORDS = 100;// 250;  

~~Listo: Colocar un save all en el editor hdl.~~

~~Listo: FoldValidProc en synhighlightersba.pas para funciones y procedimientos no funciona si la función o procedimiento tiene varios parámetros debido al ";" de separación entre parámetros. Se debe elegir otro criterio.~~
