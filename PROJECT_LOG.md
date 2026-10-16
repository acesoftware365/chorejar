# ChoreJar / Mi Mesadita — registro del proyecto

## Regla vigente del usuario: anuncios de prueba hasta envío a tiendas
Confirmada el 11 de octubre de 2026. TODOS los APK y versiones de prueba, incluso compilaciones release solicitadas por el usuario, deben utilizar exclusivamente IDs oficiales de anuncios de prueba. Pedir un APK NO autoriza activar anuncios reales. Los IDs reales de Android/iOS recibidos quedan reservados únicamente para preparar explícitamente la versión que se enviará a Google Play o App Store. No activar ADS_LIVE ni sustituir los APP IDs nativos por los reales durante desarrollo, demostraciones o pruebas. Esta regla prevalece sobre cualquier nota anterior que pudiera sugerir activarlos antes del envío a tiendas.


## Identidad, alcance y solicitud inicial
- Inglés: **ChoreJar**. Español: **Mi Mesadita**.
- Objetivo solicitado: una app Flutter bilingüe para iOS y Android que ayude a padres a administrar tareas y entregas manuales de dinero y a niños a aprender responsabilidad y ahorro.
- Alcance solicitado: varios hijos, tareas con recompensas y revisión, historial de entregas, metas y separación de permisos. Sin transferencias bancarias, publicidad ni seguimiento.
- Nombres elegidos por el usuario; disponibilidad comercial no comprobada.
- Se conserva abajo el prompt íntegro recibido. No hay contexto confirmado de conversaciones anteriores ni imagen de referencia disponible en esta sesión.

### Prompt original completo
Copia este prompt en el nuevo chat y adjunta la imagen de referencia:
Quiero diseñar y desarrollar una aplicación en Flutter para que los padres administren tareas y mesadas de sus hijos, y los niños aprendan sobre responsabilidad y ahorro.
1. Identidad del proyecto
Será una sola aplicación bilingüe para iOS y Android, con estos nombres:
- Inglés: ChoreJar
- Español: Mi Mesadita
Estos son los nombres elegidos para trabajar; su disponibilidad comercial todavía debe comprobarse. Localiza el nombre visible de la aplicación y prepara la información de las tiendas en ambos idiomas. La interfaz debe usar inicialmente el idioma compatible del teléfono, permitir cambiarlo en Ajustes y guardar esa preferencia. Mantén las traducciones separadas del código.
2. Registro permanente dentro del proyecto
Antes de implementar funciones, crea en la raíz del proyecto un documento llamado PROJECT_LOG.md. Si ya existe, léelo completo y conserva su contenido. Este documento debe guardar el historial de lo que pedimos y hacemos para poder retomar el trabajo en otro chat.
En su primera sección incluye:
- Los nombres ChoreJar y Mi Mesadita, indicando a qué idioma corresponde cada uno.
- El objetivo de la aplicación y el alcance acordado.
- Este prompt completo como solicitud inicial.
- Las decisiones confirmadas y las propuestas todavía pendientes de aprobación.
- La estructura del proyecto y las instrucciones de ejecución, cuando se hayan definido.
Añade entradas cronológicas con fecha que registren:
- Cada nueva solicitud, instrucción o corrección del usuario relacionada con el proyecto, preservando su significado y, cuando sea útil, su texto original.
- Las decisiones tomadas, sus motivos y quién las confirmó.
- Todos los comandos de terminal realmente ejecutados, para qué se usaron y su resultado. Resume las salidas extensas y conserva los errores relevantes.
- Los archivos creados, modificados, movidos o eliminados y qué cambió en cada uno.
- Dependencias instaladas o actualizadas y sus versiones.
- Pruebas realizadas, resultados y problemas pendientes.
- El estado actual, los bloqueos y los próximos pasos.
Lee este documento al comenzar o retomar el trabajo y actualízalo durante cada etapa y antes de terminar la sesión. Conserva el historial; las correcciones deben quedar como nuevas entradas. Distingue entre solicitado, propuesto, ejecutado y verificado. No registres como hecho algo que no ejecutaste ni como aprobado algo que solo sugeriste.
No guardes contraseñas, tokens, claves privadas ni información personal sensible. Sustituye esos valores por [REDACTADO]. No inventes conversaciones anteriores: registra solo el contexto disponible y señala lo que falte. Si no puedes acceder al proyecto o guardar el documento, indícalo claramente. Este registro complementará Git, sin sustituirlo.
3. Funciones para padres
Propón una primera versión que permita:
- Crear perfiles de varios hijos.
- Asignar tareas con instrucciones, frecuencia y recompensa.
- Revisar tareas completadas, aprobarlas o pedir correcciones.
- Configurar una mesada periódica, si decidimos incluirla.
- Ver cuánto dinero está pendiente de entregar a cada hijo.
- Registrar pagos entregados manualmente y consultar el historial.
- Acompañar las metas de ahorro.
En esta primera versión no habrá transferencias bancarias ni procesamiento de pagos reales. La aplicación llevará el registro del dinero que el padre entrega por fuera de la app.
4. Experiencia infantil
Cada niño podrá ver sus tareas, sus recompensas y su estado; marcar tareas como completadas para revisión; consultar su dinero y seguir una meta de ahorro, como una bicicleta.
La navegación de referencia tendrá tres secciones: Tareas, Mi dinero y Mi meta. Usa mensajes positivos y animaciones breves para celebrar avances, sin crear competencia entre hermanos.
5. Reglas del dinero
Define las reglas antes de programar. Completar una tarea no significa recibir dinero: primero debe aprobarse. Separa recompensas en revisión, dinero aprobado pendiente de recibir, dinero recibido, saldo disponible, ahorro y gastos registrados.
Registrar una entrega debe reducir lo pendiente y aumentar el saldo correspondiente. Mover dinero al ahorro no crea un ingreso adicional. Evita pagos duplicados y doble conteo. Mantén un historial que explique cada saldo y permita corregir errores con trazabilidad. Usa importes precisos, por ejemplo centavos enteros.
6. Diseño visual
Usa la imagen adjunta como referencia: fondo crema, verde esmeralda, textos azul marino, tarjetas redondeadas, botones grandes e ilustraciones suaves tipo 3D. El frasco con monedas conecta con el nombre ChoreJar. Conserva la alcancía y las metas visuales cuando aporten claridad.
Los textos e importes de la imagen son ejemplos. Diseña pantallas adaptables a teléfonos pequeños y tabletas, sin desbordamientos, con buena legibilidad, contraste y accesibilidad. El área de padres debe ser sencilla y organizada.
7. Privacidad y arquitectura
Los padres controlarán los perfiles infantiles. Solicita los mínimos datos necesarios y evita perfiles públicos o chats con desconocidos. Separa correctamente los permisos de padres e hijos. Un PIN de acceso rápido no debe sustituir la autenticación y autorización seguras.
Organiza Flutter en archivos y componentes modulares, separando pantallas, modelos, estado y servicios. Recomienda almacenamiento local o Firebase según las necesidades de sincronización; explica costos y limitaciones antes de elegir. No añadas publicidad, seguimiento ni servicios de pago sin discutirlo.
8. Forma de trabajar y entregar código
Primero revisa si existe un proyecto y su documentación. Haz únicamente las preguntas indispensables: edades objetivo, moneda, mesada fija o por tareas, dispositivos compartidos o separados y necesidad de sincronización.
Después presenta la primera versión propuesta, los flujos, las pantallas, los modelos de datos y las reglas de negocio. Validemos esa base antes de implementar funciones. Trabaja por etapas pequeñas y verificables y deja cada avance registrado en PROJECT_LOG.md.
Siempre entrega archivos completos con sus rutas, dependencias e instrucciones de ejecución. No omitas código ni sustituyas partes necesarias por puntos suspensivos. Si la entrega es extensa, divídela en grupos de archivos completos. Incluye pruebas de permisos, estados de tareas, saldos y prevención de pagos duplicados. Al cerrar cada etapa, indica qué funciona, qué se comprobó y qué falta.

## Decisiones y pendientes
**Confirmado por instrucciones del usuario:** trabajar en /Users/juanpolanco/StudioProjects/ChoreJar; el otro trabajo del usuario corresponde a otro proyecto. Mantener este registro. Validar propuesta antes de implementar funciones. Dinero en unidades menores enteras; aprobación antes de devengar recompensa; entregas manuales; historial trazable; traducciones separadas y preferencia de idioma persistente.
**Pendiente de respuesta:** edades, moneda, mesada fija además de tareas, dispositivos compartidos o separados, necesidad de sincronización.
**Pendiente de validación:** propuesta funcional y técnica de abajo. No se eligió almacenamiento ni se aprobaron nuevas dependencias.

## Estructura observada e instrucciones
- lib/main.dart: aplicación de ejemplo de Flutter (contador).
- test/widget_test.dart: prueba del contador.
- android/ e ios/: proyectos de plataforma existentes.
- pubspec.yaml: nombre chorejar, versión 1.0.0+1, Dart ^3.10.7; dependencias declaradas cupertino_icons ^1.0.8 y flutter_lints ^6.0.0, más Flutter y flutter_test del SDK. Son restricciones declaradas, no versiones verificadas del entorno.
- pubspec.lock existe. No se instalaron ni actualizaron dependencias.
- Flutter encontrado en /Users/juanpolanco/development/flutter/bin/flutter; no se verificó su versión.
- Para ejecutar, desde la raíz del proyecto: flutter pub get y flutter run con dispositivo o simulador disponible. Para verificar: flutter analyze y flutter test. Son instrucciones propuestas, **no ejecutadas** en esta etapa.
- Git: git status falló porque esta carpeta no es un repositorio Git. No se inicializó Git.

## Primera versión propuesta — pendiente de validación
### Flujos y pantallas
1. Inicio: idioma del teléfono si es español o inglés, inglés como alternativa propuesta; selector persistente en Ajustes. Nombre visible localizado y textos de tienda ES/EN en etapa de publicación.
2. Padres: resumen por hijo, perfiles, editor de tareas (instrucciones, frecuencia y recompensa), bandeja de revisión, detalle de dinero, registro de entrega, historial y metas.
3. Niños: Tareas, Mi dinero y Mi meta; detalle de tarea y envío a revisión. Mensajes positivos y celebraciones breves respetando reducción de movimiento.
4. Flujo: padre asigna → niño envía → padre aprueba o pide corrección → niño reenvía si corresponde → padre registra dinero realmente entregado.
5. Mesada periódica: fuera de la propuesta inicial hasta confirmar si se desea; si se incluye, cada periodo debe devengarse una sola vez.
6. Diseño: crema, esmeralda, azul marino, tarjetas redondeadas, botones grandes y frasco de monedas. Referencia visual pendiente; no se afirma haberla visto. Adaptación a teléfonos pequeños, tabletas, texto ampliado y lectores de pantalla.

### Modelos propuestos
- Familia: identificador, moneda, configuración.
- Padre: identidad autenticada y pertenencia autorizada a familia.
- Perfil infantil: identificador, familia, alias y avatar; recoger mínimos datos.
- Plantilla de tarea: hijo, instrucciones, frecuencia y recompensa en unidades menores.
- Ocurrencia de tarea: plantilla, periodo, recompensa fijada al asignar, estado y marcas temporales. Una tarea recurrente genera ocurrencias distintas; editar la plantilla no cambia recompensas ya aprobadas.
- Revisión: ocurrencia, decisión del padre, comentario y fecha.
- Movimiento: identificador, hijo/familia, tipo, importe, moneda, referencia de origen, clave única de operación, autor y fecha; correcciones mediante reversos vinculados.
- Entrega: importe y asignaciones a recompensas aprobadas; admite entregas parciales.
- Meta: hijo, título, importe objetivo y ahorro asignado.
- Preferencia de idioma: sistema/es/en; almacenamiento persistente.
- Si hay mesada: plan y ocurrencia por periodo con referencia única.

### Reglas de negocio propuestas
- Estados de tarea: pendiente → en revisión → aprobada; en revisión → requiere corrección → en revisión. Solo padre autoriza aprobaciones/correcciones; cada niño solo consulta y envía sus tareas.
- En revisión: informativo; no incrementa dinero aprobado ni recibido.
- Aprobar crea exactamente un derecho de cobro por ocurrencia; reenviar o repetir una aprobación no crea ingresos adicionales.
- Pendiente de recibir = recompensas aprobadas netas menos entregas netas.
- Registrar entrega de X: reduce pendiente en X y aumenta disponible en X en una única operación atómica. X positivo y no mayor que pendiente.
- Recibido = entregas netas acumuladas; es un total histórico, no otra cuenta que se suma al disponible.
- Pasar X al ahorro: disponible − X, ahorro + X; retirar ahorro hace el inverso. Ninguno aumenta recibido.
- Gastar X: disponible − X y gastos + X. Para gastar ahorro, primero retirarlo. No permitir saldo negativo.
- Invariante sin ajustes: recibido = disponible + ahorro + gastos netos. Por ejemplo: aprobar 500, entregar 300, ahorrar 100 y gastar 50 deja pendiente 200, disponible 150, ahorro 100, gastos 50, recibido 300.
- Identificadores únicos y restricciones persistentes contra operaciones duplicadas; ejecución atómica para evitar doble cobro ante reintentos o concurrencia.
- Movimientos no se borran ni sobrescriben: errores se corrigen mediante reversos con motivo y referencia. Bloquear reversos que dejen saldos negativos; resolver antes los movimientos dependientes.
- Moneda única por familia inicialmente; no cambiar moneda de un historial existente sin un diseño específico. Precisión según unidades menores de la moneda elegida.

### Arquitectura propuesta
Separar lib/app, lib/l10n, lib/models, lib/services, lib/state, lib/screens y lib/widgets; repositorios para persistencia y reglas fuera de widgets. Localizaciones en archivos ARB, no textos dispersos.
La elección local o Firebase depende de dispositivos/sincronización; no se ha tomado. Antes de elegir se explicarán costos y limitaciones con información vigente. Un PIN no sustituirá autenticación ni autorización. Las restricciones se verificarán en la capa de datos, además de la interfaz.
No hay autenticación, base de datos ni reglas de permisos implementadas todavía.

### Etapas propuestas y verificación futura
1. Validar esta base, respuestas e imagen de referencia.
2. Diseño navegable bilingüe y estructura modular.
3. Reglas de tareas y dinero con pruebas de estados, permisos, saldos, entregas parciales, duplicados y reversos.
4. Persistencia y, si corresponde, autenticación/sincronización con pruebas de acceso entre familias.
5. Verificación en pantallas pequeñas/tabletas y preparación de identidad e información de tiendas en ambos idiomas.
Ninguna de estas pruebas funcionales se ha ejecutado.

## Historial cronológico
### 2026-10-07 — America/New_York — etapa de revisión y propuesta
**Solicitado:** usuario nombró “ChoreJar app 10072026”, adjuntó prompt, indicó ruta del proyecto y preguntó si podía trabajar simultáneamente en otro proyecto. Aclaró que el otro trabajo no modifica ChoreJar y autorizó comenzar con “a pues dale”.
**Ejecutado:** lectura del adjunto, inventario del proyecto, búsqueda de instrucciones AGENTS.md en proyecto y ancestros consultados (ninguna encontrada), lectura del código inicial y documentación, localización de Flutter.
**Verificado:** existe la plantilla Flutter; el contenido leído sigue siendo el contador. No se ha ejecutado la app ni pruebas. Error Git: fatal: not a git repository (or any of the parent directories): .git. Ese error impidió la lectura concatenada del README/pubspec en ese comando; se leyeron en el siguiente.
**Consulta al usuario:** edades, moneda, mesada, dispositivos y sincronización solicitados juntos; respuesta pendiente al redactar.
**Archivos:** creado PROJECT_LOG.md con prompt íntegro, propuesta, decisiones, comandos y estado. Código de la app sin cambios.
**Dependencias:** ninguna instalada o actualizada.
**Registro de comandos realmente ejecutados:**

1. ```sh
pwd && rg --files -g AGENTS.md -g pubspec.yaml -g package.json -g README.md -g build.gradle.kts -g '*.xcodeproj' /Users/juanpolanco/StudioProjects/ChoreJar /Users/juanpolanco/StudioProjects 2>/dev/null | head -80
```
Resultado: éxito; se localizaron README, pubspec y proyectos Android.

2. ```sh
cat '/Users/juanpolanco/.codex/attachments/37ef9007-9753-42b6-af32-8a48fd4f19cd/Pasted text.txt'
```
Resultado: éxito; leído el prompt completo.

3. ```sh
ls -la /Users/juanpolanco/StudioProjects/ChoreJar; for p in /AGENTS.md /Users/AGENTS.md /Users/juanpolanco/AGENTS.md /Users/juanpolanco/StudioProjects/AGENTS.md; do if [ -f "$p" ]; then cat "$p"; fi; done; cd /Users/juanpolanco/StudioProjects/ChoreJar && rg --files -g AGENTS.md -g PROJECT_LOG.md -g '*.dart' -g '*.arb' -g '*lock' -g 'l10n.yaml' && git status --short && cat README.md pubspec.yaml
```
Resultado: salida 128 por ausencia de repositorio Git; inventario completado antes del fallo.

4. ```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && cat README.md pubspec.yaml lib/main.dart test/widget_test.dart && command -v flutter
```
Resultado: éxito; leídos README, pubspec, código y prueba inicial; Flutter localizado.

**Creación del registro:** a continuación se ejecutó un comando Python mediante heredoc que leyó el adjunto UTF-8, insertó su contenido íntegro en este documento y creó PROJECT_LOG.md en modo exclusivo; verificó que el contenido escrito coincidiera con el preparado. El comando completo se conserva en el bloque de auditoría adjunto al final del archivo.
**Estado:** revisión y propuesta documentadas; implementación pendiente de validar la base conforme al prompt del usuario. Falta imagen, respuestas y selección de almacenamiento. No hay cambios funcionales ni pruebas de funcionalidades realizadas.

### Auditoría del comando de creación
El siguiente comando se ejecutó con éxito. Esta auditoría se añadió después mediante apply_patch, sin ejecutar comandos adicionales de terminal.
```sh
python3 - <<'PY'
from pathlib import Path
import json
p = Path('/Users/juanpolanco/StudioProjects/ChoreJar/PROJECT_LOG.md')
prompt = Path('/Users/juanpolanco/.codex/attachments/37ef9007-9753-42b6-af32-8a48fd4f19cd/Pasted text.txt').read_text()
base = "# ChoreJar / Mi Mesadita — registro del proyecto\n\n## Identidad, alcance y solicitud inicial\n- Inglés: **ChoreJar**. Español: **Mi Mesadita**.\n- Objetivo solicitado: una app Flutter bilingüe para iOS y Android que ayude a padres a administrar tareas y entregas manuales de dinero y a niños a aprender responsabilidad y ahorro.\n- Alcance solicitado: varios hijos, tareas con recompensas y revisión, historial de entregas, metas y separación de permisos. Sin transferencias bancarias, publicidad ni seguimiento.\n- Nombres elegidos por el usuario; disponibilidad comercial no comprobada.\n- Se conserva abajo el prompt íntegro recibido. No hay contexto confirmado de conversaciones anteriores ni imagen de referencia disponible en esta sesión.\n\n### Prompt original completo\n<!-- INITIAL_PROMPT -->\n\n## Decisiones y pendientes\n**Confirmado por instrucciones del usuario:** trabajar en /Users/juanpolanco/StudioProjects/ChoreJar; el otro trabajo del usuario corresponde a otro proyecto. Mantener este registro. Validar propuesta antes de implementar funciones. Dinero en unidades menores enteras; aprobación antes de devengar recompensa; entregas manuales; historial trazable; traducciones separadas y preferencia de idioma persistente.\n**Pendiente de respuesta:** edades, moneda, mesada fija además de tareas, dispositivos compartidos o separados, necesidad de sincronización.\n**Pendiente de validación:** propuesta funcional y técnica de abajo. No se eligió almacenamiento ni se aprobaron nuevas dependencias.\n\n## Estructura observada e instrucciones\n- lib/main.dart: aplicación de ejemplo de Flutter (contador).\n- test/widget_test.dart: prueba del contador.\n- android/ e ios/: proyectos de plataforma existentes.\n- pubspec.yaml: nombre chorejar, versión 1.0.0+1, Dart ^3.10.7; dependencias declaradas cupertino_icons ^1.0.8 y flutter_lints ^6.0.0, más Flutter y flutter_test del SDK. Son restricciones declaradas, no versiones verificadas del entorno.\n- pubspec.lock existe. No se instalaron ni actualizaron dependencias.\n- Flutter encontrado en /Users/juanpolanco/development/flutter/bin/flutter; no se verificó su versión.\n- Para ejecutar, desde la raíz del proyecto: flutter pub get y flutter run con dispositivo o simulador disponible. Para verificar: flutter analyze y flutter test. Son instrucciones propuestas, **no ejecutadas** en esta etapa.\n- Git: git status falló porque esta carpeta no es un repositorio Git. No se inicializó Git.\n\n## Primera versión propuesta — pendiente de validación\n### Flujos y pantallas\n1. Inicio: idioma del teléfono si es español o inglés, inglés como alternativa propuesta; selector persistente en Ajustes. Nombre visible localizado y textos de tienda ES/EN en etapa de publicación.\n2. Padres: resumen por hijo, perfiles, editor de tareas (instrucciones, frecuencia y recompensa), bandeja de revisión, detalle de dinero, registro de entrega, historial y metas.\n3. Niños: Tareas, Mi dinero y Mi meta; detalle de tarea y envío a revisión. Mensajes positivos y celebraciones breves respetando reducción de movimiento.\n4. Flujo: padre asigna → niño envía → padre aprueba o pide corrección → niño reenvía si corresponde → padre registra dinero realmente entregado.\n5. Mesada periódica: fuera de la propuesta inicial hasta confirmar si se desea; si se incluye, cada periodo debe devengarse una sola vez.\n6. Diseño: crema, esmeralda, azul marino, tarjetas redondeadas, botones grandes y frasco de monedas. Referencia visual pendiente; no se afirma haberla visto. Adaptación a teléfonos pequeños, tabletas, texto ampliado y lectores de pantalla.\n\n### Modelos propuestos\n- Familia: identificador, moneda, configuración.\n- Padre: identidad autenticada y pertenencia autorizada a familia.\n- Perfil infantil: identificador, familia, alias y avatar; recoger mínimos datos.\n- Plantilla de tarea: hijo, instrucciones, frecuencia y recompensa en unidades menores.\n- Ocurrencia de tarea: plantilla, periodo, recompensa fijada al asignar, estado y marcas temporales. Una tarea recurrente genera ocurrencias distintas; editar la plantilla no cambia recompensas ya aprobadas.\n- Revisión: ocurrencia, decisión del padre, comentario y fecha.\n- Movimiento: identificador, hijo/familia, tipo, importe, moneda, referencia de origen, clave única de operación, autor y fecha; correcciones mediante reversos vinculados.\n- Entrega: importe y asignaciones a recompensas aprobadas; admite entregas parciales.\n- Meta: hijo, título, importe objetivo y ahorro asignado.\n- Preferencia de idioma: sistema/es/en; almacenamiento persistente.\n- Si hay mesada: plan y ocurrencia por periodo con referencia única.\n\n### Reglas de negocio propuestas\n- Estados de tarea: pendiente → en revisión → aprobada; en revisión → requiere corrección → en revisión. Solo padre autoriza aprobaciones/correcciones; cada niño solo consulta y envía sus tareas.\n- En revisión: informativo; no incrementa dinero aprobado ni recibido.\n- Aprobar crea exactamente un derecho de cobro por ocurrencia; reenviar o repetir una aprobación no crea ingresos adicionales.\n- Pendiente de recibir = recompensas aprobadas netas menos entregas netas.\n- Registrar entrega de X: reduce pendiente en X y aumenta disponible en X en una única operación atómica. X positivo y no mayor que pendiente.\n- Recibido = entregas netas acumuladas; es un total histórico, no otra cuenta que se suma al disponible.\n- Pasar X al ahorro: disponible − X, ahorro + X; retirar ahorro hace el inverso. Ninguno aumenta recibido.\n- Gastar X: disponible − X y gastos + X. Para gastar ahorro, primero retirarlo. No permitir saldo negativo.\n- Invariante sin ajustes: recibido = disponible + ahorro + gastos netos. Por ejemplo: aprobar 500, entregar 300, ahorrar 100 y gastar 50 deja pendiente 200, disponible 150, ahorro 100, gastos 50, recibido 300.\n- Identificadores únicos y restricciones persistentes contra operaciones duplicadas; ejecución atómica para evitar doble cobro ante reintentos o concurrencia.\n- Movimientos no se borran ni sobrescriben: errores se corrigen mediante reversos con motivo y referencia. Bloquear reversos que dejen saldos negativos; resolver antes los movimientos dependientes.\n- Moneda única por familia inicialmente; no cambiar moneda de un historial existente sin un diseño específico. Precisión según unidades menores de la moneda elegida.\n\n### Arquitectura propuesta\nSeparar lib/app, lib/l10n, lib/models, lib/services, lib/state, lib/screens y lib/widgets; repositorios para persistencia y reglas fuera de widgets. Localizaciones en archivos ARB, no textos dispersos.\nLa elección local o Firebase depende de dispositivos/sincronización; no se ha tomado. Antes de elegir se explicarán costos y limitaciones con información vigente. Un PIN no sustituirá autenticación ni autorización. Las restricciones se verificarán en la capa de datos, además de la interfaz.\nNo hay autenticación, base de datos ni reglas de permisos implementadas todavía.\n\n### Etapas propuestas y verificación futura\n1. Validar esta base, respuestas e imagen de referencia.\n2. Diseño navegable bilingüe y estructura modular.\n3. Reglas de tareas y dinero con pruebas de estados, permisos, saldos, entregas parciales, duplicados y reversos.\n4. Persistencia y, si corresponde, autenticación/sincronización con pruebas de acceso entre familias.\n5. Verificación en pantallas pequeñas/tabletas y preparación de identidad e información de tiendas en ambos idiomas.\nNinguna de estas pruebas funcionales se ha ejecutado.\n\n## Historial cronológico\n### 2026-10-07 — America/New_York — etapa de revisión y propuesta\n**Solicitado:** usuario nombró “ChoreJar app 10072026”, adjuntó prompt, indicó ruta del proyecto y preguntó si podía trabajar simultáneamente en otro proyecto. Aclaró que el otro trabajo no modifica ChoreJar y autorizó comenzar con “a pues dale”.\n**Ejecutado:** lectura del adjunto, inventario del proyecto, búsqueda de instrucciones AGENTS.md en proyecto y ancestros consultados (ninguna encontrada), lectura del código inicial y documentación, localización de Flutter.\n**Verificado:** existe la plantilla Flutter; el contenido leído sigue siendo el contador. No se ha ejecutado la app ni pruebas. Error Git: fatal: not a git repository (or any of the parent directories): .git. Ese error impidió la lectura concatenada del README/pubspec en ese comando; se leyeron en el siguiente.\n**Consulta al usuario:** edades, moneda, mesada, dispositivos y sincronización solicitados juntos; respuesta pendiente al redactar.\n**Archivos:** creado PROJECT_LOG.md con prompt íntegro, propuesta, decisiones, comandos y estado. Código de la app sin cambios.\n**Dependencias:** ninguna instalada o actualizada.\n**Registro de comandos realmente ejecutados:**\n\n1. ```sh\npwd && rg --files -g AGENTS.md -g pubspec.yaml -g package.json -g README.md -g build.gradle.kts -g '*.xcodeproj' /Users/juanpolanco/StudioProjects/ChoreJar /Users/juanpolanco/StudioProjects 2>/dev/null | head -80\n```\nResultado: éxito; se localizaron README, pubspec y proyectos Android.\n\n2. ```sh\ncat '/Users/juanpolanco/.codex/attachments/37ef9007-9753-42b6-af32-8a48fd4f19cd/Pasted text.txt'\n```\nResultado: éxito; leído el prompt completo.\n\n3. ```sh\nls -la /Users/juanpolanco/StudioProjects/ChoreJar; for p in /AGENTS.md /Users/AGENTS.md /Users/juanpolanco/AGENTS.md /Users/juanpolanco/StudioProjects/AGENTS.md; do if [ -f \"$p\" ]; then cat \"$p\"; fi; done; cd /Users/juanpolanco/StudioProjects/ChoreJar && rg --files -g AGENTS.md -g PROJECT_LOG.md -g '*.dart' -g '*.arb' -g '*lock' -g 'l10n.yaml' && git status --short && cat README.md pubspec.yaml\n```\nResultado: salida 128 por ausencia de repositorio Git; inventario completado antes del fallo.\n\n4. ```sh\ncd /Users/juanpolanco/StudioProjects/ChoreJar && cat README.md pubspec.yaml lib/main.dart test/widget_test.dart && command -v flutter\n```\nResultado: éxito; leídos README, pubspec, código y prueba inicial; Flutter localizado.\n\n**Creación del registro:** a continuación se ejecutó un comando Python mediante heredoc que leyó el adjunto UTF-8, insertó su contenido íntegro en este documento y creó PROJECT_LOG.md en modo exclusivo; verificó que el contenido escrito coincidiera con el preparado. El comando completo se conserva en el bloque de auditoría adjunto al final del archivo.\n**Estado:** revisión y propuesta documentadas; implementación pendiente de validar la base conforme al prompt del usuario. Falta imagen, respuestas y selección de almacenamiento. No hay cambios funcionales ni pruebas de funcionalidades realizadas.\n"
content = base.replace('<!-- INITIAL_PROMPT -->', prompt)
with p.open('x') as f:
    f.write(content)
assert p.read_text() == content
print('PROJECT_LOG.md creado y contenido verificado')
PY
```

### 2026-10-07 — definición de la versión básica tras respuestas del usuario
**Solicitud recibida:** “1. no se 5 - 16 tal vez, 2. permite al padre usar or elegir dependiendo del pais 3. dale la opcion al padre, 4. si para el nino y una versio para los padre , 5 si . lo mas basico posible”.
**Confirmado por el usuario:** edades aproximadas 5–16 (orientación, no restricción definitiva); moneda elegida por el padre según país; padre elige tareas, mesada o ambas; experiencias diferenciadas para niño y padre; sincronización; máxima sencillez.
**Interpretación propuesta:** una misma app con dos áreas y permisos diferentes, utilizable en dispositivos separados; no dos aplicaciones publicadas. Esto conserva el requisito original de una sola app. Una moneda por familia, sugerida por país y confirmada por el padre, sin conversiones de divisas.
**Propuesta ajustada:** inicio/configuración de familia; área Padres con hijos, tareas, revisiones y registro de entregas; área Niño con Tareas, Mi dinero y Mi meta; Ajustes con idioma, moneda inicial y modalidad de recompensa. Una meta activa por hijo inicialmente. Mesada opcional semanal o mensual; cada periodo crea pendiente de recibir una sola vez y nunca marca dinero como entregado automáticamente. Pendiente = tareas aprobadas + mesadas devengadas − entregas, neto de reversos. Resto de reglas monetarias de la propuesta anterior se conserva.
**Modelos ajustados:** Familia incorpora país, moneda y modalidad; PlanMesada incluye hijo, importe, frecuencia y fecha inicial; PeriodoMesada tiene identificador único por plan/periodo. Edades no requieren fecha de nacimiento exacta. Propuesta infantil con texto corto e iconos, uso acompañado para los más pequeños.
**Almacenamiento recomendado, pendiente de validación:** Firebase Authentication y Cloud Firestore para sincronizar y aplicar autorización por familia/perfil. Almacenamiento solo local no satisface la sincronización entre dispositivos. Spark permite comenzar sin costo dentro de cuotas; Firestore ofrece 50.000 lecturas y 20.000 escrituras diarias sin costo según documentación consultada. Al exceder cuotas sin facturación, puede interrumpirse el servicio hasta restablecerse la cuota; Blaze es pago por uso. Cloud Functions requiere Blaze, por lo que no se presupone automatización de servidor gratuita. Propuesta básica: registrar periodos vencidos al abrir el área del padre, con identificadores únicos; sin tareas programadas en servidor. No se activó facturación ni se creó servicio externo. El vínculo infantil seguro y las reglas deben diseñarse y probarse antes de usar datos reales.
**Fuentes consultadas:** https://firebase.google.com/docs/projects/billing/firebase-pricing-plans y https://firebase.google.com/pricing (búsqueda web oficial; cuotas y servicios sujetos a cambios).
**Comando de terminal ejecutado:** `cat /Users/juanpolanco/StudioProjects/ChoreJar/PROJECT_LOG.md`, para retomar el historial; salida 0. La salida del bloque de auditoría repetido se truncó en la presentación, cuyo contenido ya constaba en el contexto de la sesión.
**Cambios ejecutados:** añadida esta entrada mediante apply_patch a PROJECT_LOG.md, conservando todo el historial. Ningún archivo funcional modificado, ninguna dependencia instalada, ninguna prueba ejecutada.
**Estado y siguiente paso:** presentar al usuario la base ajustada y recomendación de almacenamiento para validación conforme a su solicitud inicial; luego construir por etapas. Imagen de referencia todavía no recibida; la descripción visual permite avanzar sin ella.

### 2026-10-07 — implementación de primera etapa visual y dominio de demostración
**Autorizado por usuario:** “dale usa un iphone pro max 17”, aceptando la propuesta y Firebase. Referencia de ejecución: iPhone 17 Pro Max, UUID 492949A9-5A9A-47B2-A9EE-98ADE015C1C3, iOS 26.2. No se detuvo el iPhone Duo ya iniciado para otro trabajo.
**Consulta pendiente:** ID del proyecto Firebase; no se conectó un proyecto ni se activó facturación.
**Ejecutado:** app navegable ES/EN con paleta crema/esmeralda, pantallas infantiles y área padre de demostración; idioma/moneda/modalidad persistidos con shared_preferences; tareas de ejemplo con revisión, correcciones, entregas parciales, ahorro y gastos; mesada semanal ilustrativa con clave única por periodo. Importes en unidades menores; JPY/CLP sin decimales. Historial monetario únicamente en memoria y etiquetado claramente como demostración. Selector de roles solo para explorar, no autenticación real.
**Archivos creados:** assets/l10n/es.json, assets/l10n/en.json, lib/l10n/strings.dart, lib/models/wallet.dart, lib/screens/home.dart, test/wallet_test.dart.
**Archivos modificados:** lib/main.dart, test/widget_test.dart (reemplaza prueba del contador), pubspec.yaml, pubspec.lock, README.md, PROJECT_LOG.md. Herramientas Flutter/CocoaPods generaron/actualizaron configuración y registro de plugins de iOS. ios/Podfile, ios/Flutter/AppFrameworkInfo.plist e ios/Runner.xcodeproj/project.pbxproj ajustados a mínimo iOS 15 por requisito del Xcode instalado. Ningún archivo de otros proyectos editado. Un intento de reemplazo de README con eliminar/añadir en un solo parche fue rechazado; se completó con dos parches secuenciales.
**Dependencias añadidas/resueltas:** flutter_localizations SDK 0.0.0 y shared_preferences 2.5.5. Transitivas nuevas: ffi 2.2.0, file 7.0.1, flutter_web_plugins SDK 0.0.0, intl 0.20.2, path_provider_linux 2.2.2, path_provider_platform_interface 2.1.3, path_provider_windows 2.3.0, platform 3.1.6, plugin_platform_interface 2.1.8, shared_preferences_android 2.4.23, shared_preferences_foundation 2.5.7, shared_preferences_linux 2.4.1, shared_preferences_platform_interface 2.4.2, shared_preferences_web 2.4.3, shared_preferences_windows 2.4.1, web 1.1.1, xdg_directories 1.1.0. Flutter reportó 19 dependencias cambiadas y versiones más nuevas fuera de restricciones, sin actualizarlas.
**Verificado:** tres pruebas pasan: transiciones/aprobación/corrección/pago parcial e invariantes; rechazo de operaciones no autorizadas/duplicadas/excesivas; navegación en 320×568, 440×956 y 1024×1366, más pantalla inicial en 320×568 con texto ampliado 2×. Analyze sin avisos. Estas son pruebas locales; no prueban autorización ni sincronización remotas.
**Problemas corregidos:** título desbordado se adapta al ancho; selector de roles más compacto; prueba de lista realiza desplazamiento para contenido fuera de pantalla.
**Pendiente:** Firebase, autenticación/vinculación infantil, reglas de datos, persistencia financiera, crear/editar hijos y tareas, mesada configurable mensual/semanal, metas editables, reversos y localización nativa del nombre/materiales de tienda. No se presenta esta etapa como app completa.
**Comandos ejecutados y resultados:**

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && tail -18 PROJECT_LOG.md && flutter --version && xcrun simctl list devices available
```
Éxito. Flutter 3.38.7 / Dart 3.10.7; iPhone 17 Pro Max iOS 26.2 disponible.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && flutter pub add shared_preferences && xcrun simctl boot 492949A9-5A9A-47B2-A9EE-98ADE015C1C3 && open -a Simulator
```
Dependencias instaladas y dispositivo iniciado. Error final: Unable to find application named 'Simulator'.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && dart format lib test && flutter analyze && flutter test
```
Formato aplicado. Analyze encontró cinco avisos curly_braces_in_flow_control_structures; no se llegó a ejecutar test.

```sh
xcode-select -p && xcrun simctl list devices booted && rg --files /Applications -g Simulator.app -g GoogleService-Info.plist 2>/dev/null | head -20
```
Xcode seleccionado; Pro Max iniciado. Aparecieron rutas de configuración de otras apps; no se leyeron ni utilizaron.

```sh
open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app --args -CurrentDeviceUDID 492949A9-5A9A-47B2-A9EE-98ADE015C1C3
```
Falló: Simulator.app no existe en esta instalación.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && dart fix --apply && dart format lib test && flutter analyze && flutter test && flutter build ios --simulator
```
Dart fix corrigió cinco avisos; analyze pasó. Dos pruebas de dominio pasaron; prueba visual falló por desbordamiento de 35 px. Compilación no ejecutada.

```sh
ls -la /Applications/Xcode.app/Contents/Developer/Applications /Users/juanpolanco/StudioProjects/ChoreJar/ios/Runner && ls /Applications
```
Falló la primera ruta; se listó ios/Runner; listado final no ejecutado.

```sh
ls /Applications
```
Éxito; inventario de aplicaciones para localizar Xcode.

```sh
ls -la /Applications/Xcode.app && xcrun --find simctl && xcodebuild -version
```
Éxito; Xcode 27.0 build 27A266a.

```sh
sed -n '55,145p' /Users/juanpolanco/StudioProjects/ChoreJar/lib/screens/home.dart && ls -la /Applications/Xcode.app/Contents && ls -la /Applications/Developer.app/Contents
```
Éxito; revisado encabezado y ubicaciones de herramientas.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && dart format lib/screens/home.dart && flutter test && flutter analyze && flutter build ios --simulator
```
Desbordamiento corregido. Prueba falló al buscar Recibido fuera de la zona construida de la lista; siguientes comandos no ejecutados.

```sh
ls /Applications/Xcode.app/Contents/Applications
```
Encontrada DeviceHub.app.

```sh
open '/Applications/Xcode.app/Contents/Applications/DeviceHub.app'
```
Éxito; abierta interfaz de dispositivos de Xcode.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && dart format test && flutter test && flutter analyze && flutter build ios --simulator
```
Tres pruebas pasaron y analyze sin avisos. Build falló: objetivo iOS 13 no compatible con Xcode instalado, cuyo mínimo es iOS 15.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && cat ios/Podfile && rg -n '13.0|MinimumOSVersion|CFBundleDisplayName' ios/Runner.xcodeproj/project.pbxproj ios/Flutter/AppFrameworkInfo.plist ios/Runner/Info.plist
```
Éxito; localizadas configuraciones iOS para ajustar mínimo.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && flutter build ios --simulator
```
Tras ajustar iOS 15, falló por arquitectura múltiple: Binary ... Flutter does not contain architectures "arm64 x86_64", aunque lipo listaba ambas.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && flutter run -d 492949A9-5A9A-47B2-A9EE-98ADE015C1C3 --no-resident
```
Iniciado; resultado se registra en entrada posterior.

### 2026-10-07 — cierre de etapa, bloqueo de ejecución iOS
**Resultado real de flutter run:** falló al copiar App.framework/flutter_assets por `No space left on device`; errores secundarios de rsync. No se instaló ni se abrió ChoreJar en el simulador. No se tomó captura ni se verificó visualmente la app en iOS. El dispositivo de referencia sí está iniciado.
**Diagnóstico ejecutado:**
```sh
df -h /Users/juanpolanco/StudioProjects/ChoreJar && du -sh /Users/juanpolanco/StudioProjects/ChoreJar/build /Users/juanpolanco/StudioProjects/ChoreJar/.dart_tool /Users/juanpolanco/StudioProjects/ChoreJar/ios/Pods
```
Salida 0: volumen de datos al 100%, 184 MiB disponibles; build del proyecto 159 MiB, .dart_tool 91 MiB, Pods 260 KiB. Limpiar solo esos archivos no daría espacio suficiente para completar cómodamente la compilación y se tendrían que regenerar. No se eliminaron datos ni cachés de otros proyectos.
**Estado final:** primera demostración escrita; flutter analyze limpio y tres pruebas locales aprobadas. Ejecución iOS no verificada por disco lleno. Compilación genérica multiarquitectura también tuvo incompatibilidad descrita arriba; usar flutter run para el dispositivo concreto al reintentar. Android no probado. Firebase pendiente de ID/configuración del propietario; no hay sincronización real.
**Próximos pasos:** liberar varios GB en el equipo y reintentar flutter run con el UUID del iPhone 17 Pro Max; conectar el proyecto Firebase cuando se proporcione acceso/configuración, implementar las funciones pendientes documentadas y probar permisos remotos. No se declara completo el objetivo de la app.

### 2026-10-07 — continuación autorizada: terminar versión básica
**Usuario:** “termina el projecto y luego lo veo”. Se continúa sin pedir decisiones menores.
**Ejecutado:** creado proyecto Firebase independiente chorejar-liisgo-2026, registrado iOS com.liisgo.chorejar y Android com.liisgo.chorejar, descargadas configuraciones móviles y generado lib/firebase_options.dart. Creada base Firestore Standard en us-east1, freeTier=true. Plan Spark verificado en consola; no se vinculó cuenta de facturación ni se habilitaron servicios de pago.
**Authentication:** configuración inicial por API devolvió CONFIGURATION_NOT_FOUND. Se inicializó desde Get started en consola Firebase con la cuenta ya conectada correspondiente al CLI; luego API habilitó Email/Password y Anonymous. No se usó initializeAuth de Identity Platform, que requiere billing según su documentación. No se enviaron correos a personas.
**Permisos:** reglas Firestore publicadas; padre autenticado administra su familia; niño anónimo se vincula con código aleatorio de un uso y 10 minutos. Cada niño consulta solo su documento y solo puede enviar tareas a revisión. Movimientos anteriores son inmutables; las correcciones añaden reversos. Versión de acceso invalida vínculos al revocar antes de su limpieza. Firestore local persistence desactivada para no conservar datos infantiles tras salir.
**Implementado:** alta/edición/archivo de perfiles, moneda familiar fija elegida con sugerencia por país, tareas editables y recurrentes, revisión/correcciones, mesada semanal/mensual, metas editables, entregas parciales asignadas a recompensas, ahorro/retiro/gastos, reversos con motivo y prevención de duplicados. Vista infantil y vista padre separadas por sesión real. Vista previa local se identifica como prueba, se guarda con archivo temporal+rename y no sube sus datos a Firebase. Idioma ES/EN separado del código; identidad nativa traducida.
**Dependencias directas resueltas:** firebase_core 4.15.0, firebase_auth 6.7.0, cloud_firestore 6.10.0, path_provider 2.1.6, intl 0.20.2. Nuevas transitivas en pubspec.lock: _flutterfire_internals 1.3.77, args 2.7.0, cloud_firestore_platform_interface 8.0.7, cloud_firestore_web 5.7.3, code_assets 1.2.1, crypto 3.0.7, firebase_auth_platform_interface 9.1.0, firebase_auth_web 6.3.0, firebase_core_platform_interface 8.1.1, firebase_core_web 3.12.0, hooks 2.0.2, http 1.6.0, http_parser 4.1.2, jni 1.1.0, jni_flutter 1.0.4+1, jni_util 1.0.0, logging 1.3.0, objective_c 9.5.0, package_config 2.2.0, path_provider_android 2.3.1, path_provider_foundation 2.6.0, pub_semver 2.2.1, record_use 0.6.0, typed_data 1.4.0, yaml 3.1.3/versión exacta a consultar en lock antes de cierre. No se instalaron Analytics, anuncios ni SDK de pagos.
**Espacio:** la escritura falló dos veces al llenarse el disco. Eliminación forzada fue rechazada por revisión automática; no se ejecutó. flutter clean tampoco pudo iniciar sin espacio. Se eliminaron sin forzado únicamente build y .dart_tool regenerables de ChoreJar; se reconstruyó pub get. No se borraron archivos de otros proyectos. Disco fluctúa entre 0 y unos cientos de MiB.
**Pruebas cloud:** primer conjunto 19 verificaciones pasó. Tras publicar reglas de versión, pruebas inmediatas observaron reglas anteriores durante propagación; reintento posterior pasó las 21 verificaciones (acceso entre familias/hermanos, vínculo, revisión, prohibición de aprobar/modificar importes/historial por niño, inmutabilidad del historial también para padre, lectura desde segunda sesión y revocación). Cuentas sintéticas @example.invalid creadas solo durante prueba y eliminadas al terminar; no se guardaron contraseñas ni tokens. Algunos intentos de limpieza anteriores devolvieron 403 al intentar borrar documentos que no llegaron a crearse o ya se habían borrado; último recorrido completó sin errores.
**Pruebas locales en curso:** dominio, almacenamiento y concurrencia pasan; se están ajustando pruebas de UI por carga asíncrona de assets con reloj de pruebas y desplazamiento de botones. Todavía no se declara suite final aprobada ni build móvil terminado.
**Archivos trabajados en esta etapa:** lib/services/repository.dart, lib/services/money.dart, lib/models/family.dart, lib/widgets/surfaces.dart, lib/screens/sign_in.dart, lib/widgets/editor.dart, lib/screens/dashboard.dart, firestore.rules, firebase.json, .firebaserc, firestore.indexes.json, lib/main.dart, (reemplazados) lib/screens/home.dart, lib/models/wallet.dart, test/wallet_test.dart, test/widget_test.dart, test/family_test.dart, test_support/cloud_smoke.cjs; además assets/l10n/es.json y en.json, test/repository_test.dart, test/widget_test.dart, pubspec.yaml/pubspec.lock, work/configure_firebase.cjs, work/generate_options.py, configuración nativa Android/iOS y PROJECT_LOG.md.
**Comandos realmente ejecutados hasta esta entrada:**

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && cat PROJECT_LOG.md && cat pubspec.yaml lib/models/wallet.dart && df -h . && command -v firebase && command -v node
```
Leídos historial y fuentes; disco 176 MiB libres. Firebase CLI y Node disponibles.

```sh
firebase projects:list --json
```
Consulta de proyectos iniciada; resultado por registrar.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && rg --files ios android lib test -g AGENTS.md -g '*firebase*' -g '*google-services*' -g '*GoogleService*' && true
```
Sin archivos de configuración Firebase encontrados.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && flutter pub add firebase_core firebase_auth cloud_firestore path_provider intl
```
Instalación de SDK Firebase y almacenamiento de archivos iniciada.

```sh
firebase projects:create chorejar-liisgo-2026 --display-name ChoreJar --json
```
Creación de proyecto independiente solicitada; sin habilitar facturación.

```sh
rm -rf /Users/juanpolanco/StudioProjects/ChoreJar/build /Users/juanpolanco/StudioProjects/ChoreJar/.dart_tool/flutter_build
```
Rechazado automáticamente: rm -f no permitido; no ejecutado. Se usa limpieza estándar Flutter.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && flutter clean
```
Limpieza estándar de artefactos regenerables de este proyecto iniciada.

```sh
rm -r /Users/juanpolanco/StudioProjects/ChoreJar/build
```
Limpieza sin opción de forzado, limitada a build generado de ChoreJar.

```sh
df -h /Users/juanpolanco/StudioProjects/ChoreJar && ls -l /Users/juanpolanco/StudioProjects/ChoreJar/lib/models/family.dart
```
Diagnóstico de espacio y archivo parcial.

```sh
firebase apps:create IOS ChoreJar --bundle-id com.liisgo.chorejar --project chorejar-liisgo-2026 --json
```
Registro de app iOS iniciado en proyecto propio.

```sh
firebase firestore:databases:create --help
```
Salida 0; consulta/configuración Firebase.

```sh
firebase apps:create ANDROID ChoreJar --package-name com.liisgo.chorejar --project chorejar-liisgo-2026 --json
```
Iniciado (sesión 11751).

```sh
node -p "require.resolve('firebase-tools')"
```
Salida 1; consulta/configuración Firebase.

```sh
firebase firestore:databases:create '(default)' --location us-east1 --project chorejar-liisgo-2026 --json
```
Salida 1

```sh
ls -l /opt/homebrew/bin/firebase && npm root -g
```
Salida 0

```sh
firebase apps:sdkconfig IOS 1:196479268137:ios:546fb5c0bb0c1c84a13338 --project chorejar-liisgo-2026 --out /Users/juanpolanco/StudioProjects/ChoreJar/ios/Runner/GoogleService-Info.plist
```
Salida 0

```sh
rg -n 'getAccessToken|function getAccount|exports.getAccount|class Client|constructor' /opt/homebrew/lib/node_modules/firebase-tools/lib/auth.js /opt/homebrew/lib/node_modules/firebase-tools/lib/apiv2.js /opt/homebrew/lib/node_modules/firebase-tools/lib/requireAuth.js
```
Leídas interfaces del CLI local para habilitar APIs con la sesión existente, sin mostrar credenciales.

```sh
sed -n '1,125p' /opt/homebrew/lib/node_modules/firebase-tools/lib/requireAuth.js && sed -n '1,85p' /opt/homebrew/lib/node_modules/firebase-tools/lib/apiv2.js
```
Salida 0

```sh
firebase apps:sdkconfig ANDROID 1:196479268137:android:54497d166f9346e1a13338 --project chorejar-liisgo-2026 --out /Users/juanpolanco/StudioProjects/ChoreJar/android/app/google-services.json
```
En curso 6589

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && node work/configure_firebase.cjs
```
Habilitación APIs y Auth en proyecto nuevo; sin imprimir tokens ni activar facturación.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && python3 work/generate_options.py
```
Opciones Firebase generadas sin imprimir claves de configuración.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && node work/configure_firebase.cjs
```
Reintento tras habilitar APIs; resultado por registrar.

```sh
firebase firestore:databases:create '(default)' --location us-east1 --project chorejar-liisgo-2026 --json
```
Reintento tras habilitar APIs; resultado por registrar.

```sh
firebase login:list --json
```
Cuenta de Firebase CLI identificada para elegir sesión coincidente en consola; datos personales no copiados al registro.

```sh
du -sh /Users/juanpolanco/StudioProjects/ChoreJar/.dart_tool /Users/juanpolanco/StudioProjects/ChoreJar/build && df -h /Users/juanpolanco/StudioProjects/ChoreJar
```
Nuevo diagnóstico tras segundo fallo de escritura por falta de espacio.

```sh
rm -r /Users/juanpolanco/StudioProjects/ChoreJar/.dart_tool
```
Eliminada caché regenerable .dart_tool de ChoreJar; pub get la reconstruirá.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && node work/configure_firebase.cjs && firebase deploy --only firestore:rules,firestore:indexes --project chorejar-liisgo-2026
```
Habilitación de proveedores/despliegue de reglas iniciado tras inicializar Authentication desde consola.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && flutter pub get && dart format lib && flutter analyze
```
Restauración caché pub, formato y análisis iniciados.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && df -h . && sed -n '1,100p' android/app/build.gradle.kts && cat android/app/src/main/AndroidManifest.xml && sed -n '1,190p' ios/Runner.xcodeproj/project.pbxproj
```
Revisión de espacio y configuración nativa para identidad/Android.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && node test_support/cloud_smoke.cjs
```
Pruebas de permisos reales con cuentas temporales sintéticas; limpieza automática en finally.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && dart fix --apply && dart format lib && flutter analyze
```
Correcciones de estilo y nuevo análisis iniciados.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && rg -n -A18 'knownRegions|PBXResourcesBuildPhase section|PBXVariantGroup section' ios/Runner.xcodeproj/project.pbxproj && sed -n '150,195p' lib/screens/sign_in.dart
```
Lectura de referencias nativas y contexto de aviso async.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && sed -n '55,140p' lib/models/family.dart && sed -n '170,235p' lib/services/repository.dart && sed -n '50,82p' lib/screens/dashboard.dart
```
Lectura de puntos para revocación robusta y ocultación al perder permisos.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && firebase deploy --only firestore:rules --project chorejar-liisgo-2026 && node test_support/cloud_smoke.cjs
```
Despliegue de revocación por versión y pruebas cloud ampliadas.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && dart format lib test && flutter analyze && flutter test --concurrency=1
```
Pruebas del dominio y flujo completo UI iniciadas, ambas localizaciones y tres tamaños.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && sed -n '25,75p' lib/services/repository.dart && sed -n '1,32p' lib/models/family.dart && df -h . && plutil -lint ios/Runner.xcodeproj/project.pbxproj
```
Revisión de persistencia y recurrencia; validación sintáctica del proyecto Xcode y espacio.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && nl -ba test/widget_test.dart | sed -n '110,150p' && node test_support/cloud_smoke.cjs
```
Diagnóstico de prueba UI y reintento cloud tras propagación de reglas.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && dart format lib test && flutter test --concurrency=1
```
Pruebas ampliadas con persistencia y escrituras concurrentes; asset preload corregido en UI.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && cat firestore.rules && rg -n 'accessVersion|const inv|function child' test_support/cloud_smoke.cjs
```
Diagnóstico preciso del rechazo de invitación tras endurecer reglas.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && node test_support/cloud_smoke.cjs
```
Diagnóstico de versión y reloj en documentos sintéticos.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && flutter test test/widget_test.dart --concurrency=1
```
Pruebas UI con traducciones inyectadas para aislar la carga de assets del reloj simulado.



## 2026-10-07 — cierre de implementación básica y validación

Implementación guardada en el proyecto indicado. Firebase real configurado y reglas desplegadas. Resultado final: 11 pruebas locales aprobadas (dominio, persistencia, concurrencia, flujo padre/niño y diseño ES/EN), 21 comprobaciones cloud aprobadas con limpieza de datos sintéticos, análisis Flutter sin incidencias. Plist de app, Firebase y proyecto Xcode válidos. Dependencia yaml confirmada en pubspec.lock: 3.1.4.

El disco físico quedó al 100% (~260 MiB disponibles). Los intentos de pruebas sobre disco fallaron por espacio; la suite completa pasó usando un disco RAM temporal propio de 512 MiB. Se retiró el enlace build y se expulsó /dev/disk18 al finalizar. No se modificaron otros proyectos. La compilación/instalación nativa iOS y Android queda pendiente; no hay evidencia de ejecución de ChoreJar en el simulador iPhone 17 Pro Max y no se declara verificada. README y checklist de publicación indican estos límites.

Se añadió test_support/render_preview.dart, ejecutable con flutter test, para generar una vista infantil con datos sintéticos en proporciones 440×956. La primera captura se interrumpió por una espera de rasterización dentro del reloj simulado; corregida con runAsync. La exportación final pasó y fue inspeccionada visualmente, con fuente de iconos cargada explícitamente. No es una captura de simulador. Salida: /Users/juanpolanco/Documents/Codex/2026-10-07/chore/outputs/chorejar-preview.png.

Icono original generado con herramienta integrada image_gen, sin referencia; original y prompt preservados en assets/brand/GENERATION.txt. Prompt: original iOS/Android icon for ChoreJar / Mi Mesadita, ages 5–16; opaque warm cream background #FAF7EF; centered emerald-green glass savings jar with golden coins, polished 3D, navy accents; no words, currency symbols, faces, watermark, transparency or outer rounded-square border. Variantes nativas redimensionadas con sips. Verificado 1024×1024 sin alfa. Copia entregable: /Users/juanpolanco/Documents/Codex/2026-10-07/chore/outputs/chorejar-icon.png.

### Comandos restantes y resultados

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && dart format lib test && flutter analyze && flutter test --concurrency=1
```
Suite completa tras corregir pruebas de desplazamiento y mesadas en meses cortos.

```sh
cat /Users/juanpolanco/.codex/skills/.system/imagegen/SKILL.md
```
Leída habilidad imagegen para icono original de la app.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && python3 work/install_icon.py
```
Icono generado copiado, redimensionado a tamaños de plataforma y enlazado en catálogo iOS; original conservado.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && dart format lib test && flutter analyze && flutter test --concurrency=1
```
Suite final tras incorporar icono y ajustar interacción UI.

```sh
df -h /Users/juanpolanco/StudioProjects/ChoreJar && ls '/System/Library/Fonts/Supplemental/Arial.ttf'
```
Comprobación espacio y fuente disponible para vista previa visual.

```sh
df -h /Users/juanpolanco/StudioProjects/ChoreJar && ps -axo pid,etime,command | rg 'flutter_tester|frontend_server|flutter_tools.snapshot test' | head -12
```
Diagnóstico de ejecución de pruebas detenida en carga.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && flutter test test/widget_test.dart --no-pub --reporter expanded
```
Reintento aislado UI tras interrumpir solo la sesión de pruebas propia detenida.

```sh
du -sh /Users/juanpolanco/StudioProjects/ChoreJar/build/test_cache /Users/juanpolanco/StudioProjects/ChoreJar/.dart_tool && df -h /Users/juanpolanco/StudioProjects/ChoreJar
```
Inspección de caché de pruebas y disco.

```sh
for p in /var/folders/rt/0hcrf5xx4n32r8_b874t84380000gn/T/flutter_tools.wZ6aPV /var/folders/rt/0hcrf5xx4n32r8_b874t84380000gn/T/flutter_tools.Ye3Obc /var/folders/rt/0hcrf5xx4n32r8_b874t84380000gn/T/flutter_tools.o7kEXP; do if [ -d "$p" ]; then du -sh "$p"; fi; done
```
Inspección únicamente de directorios temporales identificados en ejecuciones propias de ChoreJar.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && flutter test --help | rg -n 'track|pub|concurr|asset' && df -h .
```
Consultadas opciones locales para reducir archivos temporales de pruebas.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && rm -r build && flutter test --no-pub --no-track-widget-creation --no-test-assets --concurrency=1 --reporter expanded
```
Eliminada solo compilación propia; suite sin metadata del inspector ni assets innecesarios para reducir espacio temporal.

```sh
sysctl -n hw.memsize && hdiutil attach -nomount ram://1048576
```
Intento de disco RAM temporal de 512 MiB para pruebas, sin borrar datos ni cambiar otros proyectos.

```sh
diskutil info /dev/disk18
```
Verificación del dispositivo RAM recién creado antes de formatearlo.

```sh
diskutil eraseVolume HFS+ ChoreJarScratch /dev/disk18
```
Formato únicamente del disco RAM virtual propio de 512 MiB, verificado como sin sistema de archivos; no disco físico.

```sh
diskutil info /dev/disk18 | rg 'Mount Point|Volume Name'
```
Ruta del volumen temporal confirmada.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && mkdir -p /Volumes/ChoreJarScratch/work /Volumes/ChoreJarScratch/build && rm -r build && ln -s /Volumes/ChoreJarScratch/build build && TMPDIR=/Volumes/ChoreJarScratch/work flutter test --no-pub --concurrency=1 --reporter expanded
```
Pruebas con TMPDIR y build propios en RAM; ninguna configuración global modificada.

```sh
sips -g pixelWidth -g pixelHeight -g hasAlpha /Users/juanpolanco/StudioProjects/ChoreJar/assets/brand/chorejar-icon.png
```
Validación de resolución y canal alfa del icono iOS.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && TMPDIR=/Volumes/ChoreJarScratch/work flutter test test_support/render_preview.dart --no-pub --reporter expanded
```
Renderizado de vista previa con datos sintéticos a proporciones 440×956; no captura de simulador.

```sh
cd /Users/juanpolanco/StudioProjects/ChoreJar && dart format lib test test_support/render_preview.dart && flutter analyze && plutil -lint ios/Runner.xcodeproj/project.pbxproj ios/Runner/Info.plist && rg -A7 '^  yaml:' pubspec.lock
```
Verificación estática final, sintaxis Xcode y versión yaml resuelta.

```sh
sed -n '60,110p' /Users/juanpolanco/StudioProjects/ChoreJar/test_support/render_preview.dart
```
Lectura del exportador visual para corregir ejecución asíncrona del render.

```sh
TMPDIR=/Volumes/ChoreJarScratch/work flutter test test_support/render_preview.dart --no-pub --reporter expanded
```
Exportación visual corregida para ejecutar captura fuera de FakeAsync.

```sh
flutter analyze --no-pub
```
Verificación final

```sh
plutil -lint ios/Runner/Info.plist ios/Runner/GoogleService-Info.plist ios/Runner.xcodeproj/project.pbxproj
```
Verificación final

```sh
tail -65 PROJECT_LOG.md
```
Verificación final

```sh
cat README.md; rg -A 7 '^  yaml:' pubspec.lock
```
Verificación final

```sh
TMPDIR=/Volumes/ChoreJarScratch/work flutter test test_support/render_preview.dart --no-pub --reporter expanded
```
Carga explícita de MaterialIcons para la captura del test; la primera captura no cargó esa fuente.

```sh
flutter analyze --no-pub
```
No issues found.

```sh
rm /Users/juanpolanco/StudioProjects/ChoreJar/build
```
Retirado enlace simbólico temporal de compilación.

```sh
hdiutil detach /dev/disk18
```
Retirada del disco RAM temporal propio.

Los estados anteriores de «iniciado» o «verificación» se resuelven con los resultados finales documentados arriba. Las interrupciones de intentos sobre disco y el primer exportador no representan fallos de la suite final.


## 2026-10-08 — interfaz infantil según referencia aportada
El usuario rechazó el diseño infantil anterior y pidió expresamente el de 424E1F12-8022-4118-ADA1-5A0AA129DD3D.PNG; reiteró «así es que la quiero». Se implementó una pantalla infantil independiente con fondo crema, tipografía Nunito redondeada, frasco transparente 3D, saldo pendiente grande, última recompensa aprobada no revertida, tarjeta de ahorro con progreso y navegación Tareas/Mi dinero/Mi meta. Las sesiones infantiles abren Mi dinero; la previsualización de padres conserva su pestaña para no romper el flujo de tareas. El saldo y la meta provienen del perfil y el historial reales. Tocar el saldo abre el detalle; la tarjeta abre la meta. La bicicleta se muestra solo para metas cuyo nombre indica bicicleta. Cero recompensas muestra invitación a empezar, sin inventar ganancias.

Archivos modificados: lib/screens/dashboard.dart, pubspec.yaml, assets/l10n/es.json, assets/l10n/en.json, test_support/render_preview.dart. Añadidos: lib/widgets/child_money.dart, test/child_money_test.dart, assets/child/{money-jar.png,piggy-bank.png,bicycle.png,GENERATION.txt}, assets/fonts/Nunito*.ttf y OFL.txt. Ilustraciones creadas con image_gen integrado usando la referencia, inspeccionadas e integradas; prompts completos y rutas en GENERATION.txt y entregable outputs/recursos-interfaz.txt. Fuente descargada del repositorio oficial google/fonts; originales preservados.

Validación final: flutter analyze --no-pub sin incidencias; 12 pruebas locales aprobadas, incluidas nuevas comprobaciones de saldo infantil actualizado, navegación, ausencia de aprobación infantil, ES/EN y pantalla pequeña con texto 2×. Exportador visual pasó y la imagen final fue inspeccionada. Primer render requirió precargar imágenes; fuente variable sustituida por instancias estáticas para respetar pesos; restauración de debugDisableShadows corregida antes del cierre del test. La prueba de meta se corrigió para desplazar su lista en pantallas pequeñas, donde el contenido no estaba construido todavía. No se modificaron backend ni reglas, por lo que no se repitió el smoke cloud.

Comandos relevantes ejecutados (sin secretos):
- rg --files y lecturas sed/cat de código, skill imagegen, historial y configuración; búsqueda de AGENTS.md en proyecto/ancestros sin instrucciones adicionales.
- df -h .: disco al 100%, aproximadamente 565 MiB libres; compilación nativa sigue pendiente.
- curl -fL https://raw.githubusercontent.com/google/fonts/main/ofl/nunito/Nunito%5Bwght%5D.ttf -o assets/fonts/Nunito.ttf
- curl -fL https://raw.githubusercontent.com/google/fonts/main/ofl/nunito/OFL.txt -o assets/fonts/OFL.txt
- flutter pub get: correcto, sin cambio de versiones solicitado.
- dart format lib test/child_money_test.dart test_support/render_preview.dart.
- flutter analyze --no-pub: No issues found.
- hdiutil attach -nomount ram://1048576; diskutil info /dev/disk18: verificado disco imagen virtual nuevo de 536870912 bytes y sin filesystem.
- diskutil eraseVolume HFS+ ChoreJarScratch /dev/disk18: formateado exclusivamente disco RAM propio.
- mkdir -p /Volumes/ChoreJarScratch/work /Volumes/ChoreJarScratch/build; ln -s /Volumes/ChoreJarScratch/build build.
- python3 -m pip install --target /Volumes/ChoreJarScratch/fonttools fonttools: instalado temporalmente 4.60.2; no paquetes globales modificados.
- PYTHONPATH=/Volumes/ChoreJarScratch/fonttools python3: fontTools.varLib.instancer generó pesos 400,700,800,900.
- cp de cada PNG generado a assets/child: originales conservados.
- TMPDIR=/Volumes/ChoreJarScratch/work flutter test --no-pub --concurrency=1 --reporter expanded: 12 aprobadas.
- TMPDIR=/Volumes/ChoreJarScratch/work flutter test test_support/render_preview.dart --no-pub --reporter expanded: exportación aprobada.
- rm /Users/juanpolanco/StudioProjects/ChoreJar/build: retirado solo enlace temporal.
- diskutil eject /dev/disk18: disco RAM propio expulsado correctamente.

Entrega visual: /Users/juanpolanco/Documents/Codex/2026-10-07/chore/outputs/chorejar-child-reference.png. Es un render real de widgets Flutter con datos sintéticos ($12.50 pendientes, última recompensa $2, ahorro al 57%) a 440×956 puntos; no captura de ejecución nativa. Persisten los límites de compilación nativa por espacio, ya documentados. No se tocaron otros proyectos.

## 2026-10-08 — abrir en modo niño
Solicitud: «runs it un child mode». Disco físico al 100%, 334 MiB libres; simulador iPhone 17 Pro Max ya iniciado, pero sin espacio suficiente para compilar nativo. Se creó entrada aislada lib/main_child_preview.dart con perfil sintético infantil, sin inicializar Firebase, sin leer familias reales y con escrituras de padre bloqueadas. Las tareas se pueden enviar en memoria y los datos se reinician al recargar. Se añadió web/index.html como soporte de ejecución.
Comandos: dart format lib/main_child_preview.dart; flutter analyze --no-pub (sin incidencias); TMPDIR=/Volumes/ChoreJarPreview/tmp flutter build web --target lib/main_child_preview.dart --no-pub --no-wasm-dry-run (compilación exitosa en 13.8 s). Se usó un disco RAM nuevo de 1 GiB: hdiutil attach -nomount ram://2097152, diskutil info /dev/disk18 verificado virtual/sin filesystem, diskutil eraseVolume HFS+ ChoreJarPreview /dev/disk18. Resultado web de 36 MiB copiado a work/child-preview. Enlace build retirado y diskutil eject /dev/disk18 completado.
Servidor local activo: python3 -m http.server 8317 --bind 127.0.0.1 --directory /Users/juanpolanco/StudioProjects/ChoreJar/work/child-preview (sesión 18931). Abierto http://127.0.0.1:8317 en navegador integrado, pestaña 2 marcada como entregable. Verificado visualmente modo niño Mi dinero, datos de prueba, saldo $12.50, última recompensa $2 y navegación inferior. Viewport 440×956 conservado por preferencia previa de iPhone Pro Max. Ejecución web confirmada; no ejecución nativa ni sincronización real en esta vista.

## 2026-10-08 — catálogo visual de metas
Usuario pidió poder elegir imágenes de artículos para la meta de su hija, especialmente iPhone. Se añadieron opciones iPhone, bicicleta, videojuegos, audífonos y regalo. Tres PNG originales generados con image_gen integrado, fondo transparente, inspeccionados y copiados a assets/child/{iphone,console,headphones}.png. Prompts/rutas completos en assets/child/GOAL_IMAGES.txt y outputs/imagenes-metas.txt. Se conservan originales generados.
Cambios: goalImage se serializa con el perfil, valida valores permitidos y admite perfiles antiguos sin ese campo (auto). GoalImage común muestra la elección en tarjeta de ahorro y detalle de meta. Editor con ChoiceChip visual, nombre y precio editables, traducciones ES/EN. Edición real conservada para padres; vista local permite personalizar la meta. PreviewRepository solo permite cambios de los tres campos de meta, bloquea cambios de dinero y guarda elección en SharedPreferences del navegador. Demo predeterminada Mi iPhone; importe demo previo de 100 USD conservado, no representa precio de mercado.
Archivos: lib/models/family.dart, lib/widgets/{goal_image,editor,child_money}.dart, lib/screens/dashboard.dart, lib/main_child_preview.dart, assets/l10n/{es,en}.json, test/family_test.dart y assets/child.
Validación: flutter analyze --no-pub sin incidencias; 13 pruebas locales aprobadas, incluida compatibilidad de perfiles antiguos y persistencia/validación del identificador de imagen. Flutter build web --target lib/main_child_preview.dart --no-pub --no-wasm-dry-run exitoso en 13.6 s. Selector probado en navegador: cambiar a audífonos y volver a iPhone, guardar y reabrir muestra iPhone seleccionado. Corregida marca gigante de selección con showCheckmark:false; la selección sigue indicada por fondo y semántica.
Comandos: lectura de archivos e historial; dart format lib y test/family_test.dart; dart fix --apply --code curly_braces_in_flow_control_structures; flutter analyze --no-pub; TMPDIR=/Volumes/ChoreJarPreview/tmp flutter test --no-pub --concurrency=1 --reporter expanded; construcción web citada; cp de assets y cp -R build/web/. work/child-preview/. Para cada compilación se creó disco RAM virtual propio de 1 GiB con hdiutil attach -nomount ram://2097152, verificado con diskutil info /dev/disk18 antes de diskutil eraseVolume HFS+ ChoreJarPreview /dev/disk18; build fue enlace temporal. No se modificaron reglas Firebase ni otras familias. Servidor local continúa en puerto8317.
Cierre: recompilación visual final correcta (13.7 s); archivo web actualizado, enlace build retirado y disco RAM expulsado. Tras activación de actualización del navegador se verificó selector sin marca sobredimensionada, iPhone seleccionado y nombre conservado tras recarga. Selector queda abierto en pestaña2, marcado entregable, 440×956. Captura real de navegador: outputs/selector-metas.png. No es simulador nativo.

## 2026-10-08 — biblioteca ligera de assets
Solicitud: crear biblioteca que consuma poco espacio. Se midieron siete PNG originales: 7769457 bytes. Se generaron WebP con sharp del runtime existente (sin instalaciones ni imágenes nuevas), calidad82/alfa95, frasco máximo768px, metas/alcancía384px, marca256px. Total final 200678 bytes (201 KB decimales, 196 KiB), reducción97.4%; conserva alfa donde correspondía. Esta cifra es solo imágenes, no toda la app. Originales movidos a design/source-images, fuera del paquete; iconos nativos de tienda sin cambios.
Catálogo reutilizable lib/assets/library.dart con IDs estables, rutas, dimensiones; IDs de metas compartidos por validación y selector. Pantallas de acceso, dinero y metas usan recursos WebP; regalo usa icono existente. pubspec incluye únicamente assets/library y traducciones, además de fuentes declaradas. Actualizado exportador visual. Nuevos tool/optimize_assets.cjs, design/ASSET_LIBRARY.txt, design/asset-sizes.json y test/asset_library_test.dart; README actualizado. Catálogo de siete recursos comprobado, sin duplicación por perfil; test impone límite300KiB.
Comandos: du -ah assets; descubrimiento de dependencias runtime; NODE_PATH=/Users/juanpolanco/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules node tool/optimize_assets.cjs; mv de PNG a design/source-images; dart format lib y test/asset_library_test.dart; flutter analyze --no-pub (sin incidencias); TMPDIR=/Volumes/ChoreJarPreview/tmp flutter test --no-pub --concurrency=1 --reporter expanded (14 aprobadas); flutter build web --target lib/main_child_preview.dart --no-pub --no-wasm-dry-run (éxito13.4s). Usado disco RAM1GiB propio creado con hdiutil attach -nomount ram://2097152, verificado diskutil info /dev/disk18 virtual/sin filesystem, formateado ChoreJarPreview; enlace temporal build retirado y diskutil eject /dev/disk18 correcto al terminar.
rsync -a --delete build/web/ work/child-preview/ sincronizó solo la salida generada propia, retirando las viejas copias PNG del servidor. Verificado contenido de assets/assets: fonts,l10n,library; sin directorios child/brand antiguos en el paquete. Servidor8317 sigue activo. Informe entregable outputs/biblioteca-assets.txt. No se alteraron backend, cuentas ni otros proyectos.

## 2026-10-09 — vista de padres e icono nuevo
Usuario pidió ver versión de padres y crear icono. Se añadió lib/main_parent_preview.dart como entrada de demostración independiente usando la interfaz real Dashboard y repositorio en memoria con varios perfiles, edición de tareas, aprobación y movimientos. Sin Firebase ni familias reales. Las modificaciones de esta demo se reinician al recargar. Compilada en ruta /parent/; vista infantil raíz conservada. Servidor anterior estaba detenido: reiniciado python3 -m http.server 8317 --bind 127.0.0.1 --directory /Users/juanpolanco/StudioProjects/ChoreJar/work/child-preview (sesión63835). Vista de padres abierta y verificada visualmente en navegador integrado, 440×956, con controles Añadir hijo, Editar perfil, Ver como niño, Añadir tarea y navegación.
Icono v2 generado con image_gen integrado, frasco de vidrio verde y monedas doradas con estrellas, fondo crema, sin texto. Prompt y rutas en design/APP_ICON_V2.txt y outputs/icono-app-detalles.txt. Original anterior preservado. Instalado master1024×1024 sin alfa en design/source-images/chorejar-icon-v2.png y outputs/chorejar-icon-v2.png; variantes iOS chorejar-v2-*.png y Android chorejar_icon_v2.png, manifiestos actualizados. Favicon web y WebP ligero7286bytes; AssetLibrary.brand apunta a v2, versión WebP anterior archivada fuera del paquete. Añadido tool/install_app_icon.cjs, actualizado tool/optimize_assets.cjs para regenerar v2 y título web genérico ChoreJar.
Comandos: lecturas historial/configuraciones, df -h (2.6GiB disponibles), dart format lib/main_parent_preview.dart, flutter analyze --no-pub (sin incidencias), flutter test --no-pub --concurrency=1 --reporter expanded (14 aprobadas), flutter build web --target lib/main_parent_preview.dart --base-href /parent/ --no-pub --no-wasm-dry-run (build inicial25.2s y final15.7s), rsync -a --delete build/web/ work/child-preview/parent/. No disco RAM necesario. Instalador ejecutado con sharp del runtime y PNG generado exec-0afc8569-6d7d-44f1-ad6b-62a690962d50.png. plutil -lint no admite este Contents.json como plist; comprobación correcta posterior con JSON.parse y sharp verificó todas las dimensiones iOS y ausencia de alfa. La compilación nativa sigue sin verificarse. Ningún otro proyecto fue modificado.

## 2026-10-09 — botón rojo para eliminar un niño
Usuario pidió botón rojo en perfil del niño con advertencia antes de borrar. Se interpretó como perfil infantil dentro del área de padres: acción no disponible al niño. Añadido botón Eliminar niño junto a acciones del perfil; diálogo identifica el nombre y advierte borrado irreversible de perfil/tareas/movimientos/meta, revocación de acceso, conservación de otros niños y alternativa Archivar. Cancelar no modifica datos; Eliminar definitivamente inicia operación, con estado ocupado y errores controlados.
Interfaz FamilyRepository ampliada con deleteChild; repositorio local usa escritura atómica serializada; cloud exige parent, revoca enlaces/invitaciones y acceso antes de borrar documento con historial embebido. Preview infantil rechaza, preview padre borra solo perfil indicado. No se ejecutó borrado de datos reales. No cambian reglas Firebase: ya permiten delete al padre. Archivos actualizados dashboard.dart, repository.dart, entradas preview, traducciones ES/EN y README.
Pruebas añadidas: cancelar conserva todos los perfiles; confirmar borra únicamente seleccionado; borrado local persiste tras reabrir y conserva hermano; acción ausente de pantalla infantil. 16 pruebas locales pasan. flutter analyze --no-pub sin incidencias. Comandos: lecturas con rg/sed/tail; dart format lib test; flutter test --no-pub --concurrency=1 --reporter expanded; flutter build web --target lib/main_parent_preview.dart --base-href /parent/ --no-pub --no-wasm-dry-run (13.5s); rsync -a --delete build/web/ work/child-preview/parent/. Compilación web correcta, sin compilación nativa ni prueba de borrado cloud real en esta petición.
Al verificar UI se detectó formulario con texto introducido por usuario. Se conservó pestaña1 sin recargar, y se abrió pestaña2 con actualización para no perder borrador. No se confirmó eliminación desde navegador.
Verificación visual final: el navegador8317 conservaba traducciones antiguas por caché; se abrió la demo actualizada en puerto8318 (python3 http.server, sesión54873) sin tocar formulario del usuario en8317. En8318 se verificaron Eliminar niño y diálogo completo traducido. Solo se abrió la advertencia, no se confirmó borrado. Captura outputs/advertencia-eliminar-nino.png. Ambas pestañas marcadas para conservarse, original con borrador intacto y actualización con advertencia visible.

## 2026-10-09 — posición del botón Eliminar niño
Usuario pidió moverlo al extremo derecho de la fila del nombre. Se trasladó el mismo botón rojo a Row junto al encabezado del perfil, con espacio flexible para nombres y texto grande. Permisos y confirmación sin cambios. dart format lib/screens/dashboard.dart; flutter test test/widget_test.dart --no-pub --concurrency=1 --reporter expanded: 3 pruebas aprobadas (borrado/cancelación, tamaños/idiomas/texto2× y flujo de tareas). flutter build web --target lib/main_parent_preview.dart --base-href /parent/ --no-pub --no-wasm-dry-run correcto14.3s; rsync de salida generada a work/child-preview/parent/. Formulario original del usuario conserva texto, no se recarga.
Ajuste final: Align.topRight en espacio flexible para tocar margen derecho sin dejar hueco. Nueva compilación web correcta41.4s y 3 pruebas UI repetidas tras el ajuste: aprobadas. Actualizada demo generada.

## 2026-10-09 — acceso compartido para dos padres
Solicitud: permitir dos padres en la app de padres. Implementados invitación privada de un uso/10 minutos, registro o inicio de sesión con código, reanudación mediante parentLinks, slot único parentMembers y verificación transaccional de reciprocidad. Máximo dos adultos, cuentas diferentes, sin fusión de familias existentes. Ambos gestionan perfiles/tareas/saldos. Creador gestiona invitaciones y borrado de familia; segundo adulto puede salir o borrar solo su cuenta. Revocación atómica de slot/enlace; UI Ajustes → Acceso para dos padres. Demo muestra explicación honesta sin crear accesos reales. Traducciones ES/EN.
Reglas desplegadas con firebase deploy --only firestore:rules --project chorejar-liisgo-2026: compilación/despliegue correcto. Cloud smoke ampliado: 43 comprobaciones aprobadas usando cuentas y documentos sintéticos eliminados al finalizar. Incluye canje atómico, edición compartida, tercero bloqueado, anónimo bloqueado, código usado rechazado, revocación, salida voluntaria, conservación de familia, permisos infantiles e inmutabilidad del historial. Primer intento detectó error del fixture: envío infantil restablecía nombre anterior tras edición del segundo padre; corregido para conservar el nombre, reglas intactas.
Validación local: 16 tests existentes aprobados; posteriormente 4 tests de widgets aprobados incluyendo nuevo flujo de invitación y mensaje de demo. flutter analyze --no-pub sin incidencias. dart format y dart fix de llaves. flutter build web --target lib/main_parent_preview.dart --base-href /parent/ --no-pub --no-wasm-dry-run: correcto13.7s. rsync -a --delete build/web/ work/child-preview/parent/. Navegador verificado en nueva pestaña /parent/?parents=two, conserva pestañas previas sin recargar. No compilación nativa en esta petición, no invitación a personas reales ni envío de mensajes. README actualizado.

## 2026-10-10 — invitación sencilla para padres
Usuario aceptó simplificar para padres con poca experiencia tecnológica. Botón Añadir otro padre, explicación breve, pasos numerados y Compartir invitación mediante selector del sistema; copiar mensaje completo como alternativa. Enlace chorejar://join-parent con código, parser estricto de ruta/formato, pantalla Te invitaron a la familia, invitación preparada sin código largo a la vista y Pegar invitación por acción explícita. Requiere app instalada; no se afirma enlace universal web ni instalación automática. Autenticación y canje siguen explícitos, no se unen familias automáticamente. No se envió invitación a ninguna persona.
Dependencias app_links7.0.0 y share_plus13.3.1 resueltas con flutter pub add; Android AGP8.12.1 para requisito de share_plus, Gradle8.14/Kotlin2.2.20 existentes. Configurados esquema iOS/Android y desactivado manejador Flutter duplicado. Consultada documentación primaria pub.dev de ambos paquetes. Cambios en main, sign_in, dashboard, ParentInvitation, traducciones ES/EN, manifests y tests.
flutter analyze --no-pub inicial limpio. Suite completa20 tests aprobados, incluyendo parsing de mensaje/enlace/código y rechazo de rutas ajenas, pantalla prellenada y demo sin sincronización. Último ajuste oculta código bajo alternativa cuando invitación lista; se repiten widgets y análisis. No cambian reglas/backend; no se repiten pruebas cloud43 previas. Espacio inicial533MiB; no se intenta build nativa. Integración nativa de apertura/compartir pendiente de prueba en dispositivos instalados, no se declara verificada.
Validación final: cinco pruebas widget aprobadas tras ocultar código; análisis sin incidencias, Info.plist válido. Build web padre correcto59.3s y rsync de salida a work/child-preview/parent/. No se compilaron iOS/Android.

## 2026-10-10 — asistente inicial de cuatro pasos
Usuario aprobó asistente para padres poco familiarizados con tecnología. Nueva WelcomeFlow con botones Soy mamá o papá / Soy un niño, accesos separados Entrar / Recibí una invitación. Cuenta nueva muestra Paso1de4 y datos existentes de país/moneda; familia sin perfiles continúa por nombre/avatar, primera tarea con recompensa editable o saltar, y confirmación. Usuarios invitados y niños omiten creación de familia; familias existentes entran a su pantalla. Reanudación de cuenta sin perfiles retoma alta infantil. ID estable evita duplicar perfil al reintentar un resultado ambiguo; creación de cuenta no se repite si ya tuvo éxito en ese intento. No se añaden cambios de reglas Firebase.
Entrada aislada main_welcome_preview.dart permite probar sin Firebase, credenciales ni datos reales; su repositorio empieza vacío y se reinicia al recargar. Pantallas existentes de padre/niño conservadas en sus rutas. Textos ES/EN y controles de progreso. Tarea opcional; invitación del segundo padre y enlace infantil se explican como opciones posteriores en Ajustes.
Validación: 22 pruebas locales aprobadas, incluyendo recorrido completo, nombre requerido, volver atrás conservando datos, importe exacto y omitir tarea sin movimientos. dart format y dart fix llaves. No creación de cuentas reales ni compilación nativa en esta petición.
Cierre: flutter analyze --no-pub sin incidencias; flutter build web --target lib/main_welcome_preview.dart --base-href /welcome/ --no-pub --no-wasm-dry-run correcto23.7s. Sincronizado únicamente work/child-preview/welcome/. Bienvenida verificada visualmente en navegador440×956, abierta para el usuario en http://127.0.0.1:8318/welcome/. Captura outputs/inicio-paso-a-paso.png. No se modificaron datos de otras pestañas.

## 2026-10-10 — simplificar pantalla de dinero del padre
A partir de captura del usuario: sustituido bloque hero y saldo pendiente repetido por tarjeta compacta «Pendiente de entregar» con acción Registrar entrega integrada. Resumen conserva Disponible/Ahorrado. En revisión/Recibido/Gastado y operaciones ahorro/retiro/gasto están en desplegable Ver detalles y otras opciones; historial también desplegable. Aviso accionable de tareas por revisar solo cuando hay importe en revisión. Sin cambios contables ni eliminación de movimientos. Botón rojo de eliminar junto al nombre conserva posición previamente solicitada; quitado subtítulo Mi familia en esta pestaña. ES/EN. Análisis limpio y cinco pruebas widget previas aprobadas; se añadió prueba específica de visibilidad/despliegue de operaciones. Se reconstruyen las demos welcome y parent sin recargar la pestaña con los datos introducidos por el usuario.
Resultado final: 6 tests widget aprobados (incluye el nuevo), builds welcome17.6s y parent17.3s correctos, ambas salidas actualizadas. Nueva pestaña de demo abierta en Mi dinero y verificada en440×956; captura outputs/dinero-simplificado.png. Perfil Ashley y pestaña original no se recargan ni modifican. No pruebas nativas ni cambios cloud.

## 2026-10-10 — metas elegidas por niños y catálogo ampliado
Solicitud: explicar vinculación infantil y permitir elegir metas con más imágenes bonitas. Explicado flujo padre → Ajustes/Vincular dispositivo infantil → código de un uso10min → Soy un niño en dispositivo infantil. No se vinculó dispositivo real.
Niños conectados pueden modificar únicamente goalName, goalImage y goalAmount de su perfil no archivado. CloudRepository.chooseGoal transaccional actualiza solo esos campos; reglas validan identificador del catálogo, nombre1–120 e importe entero positivo hasta1e9 unidades menores. No permiso para dinero, tareas, otros niños o resto del perfil. UI habilitada para niño cloud; seleccionar imagen rellena nombre editable. Reglas desplegadas correctamente con firebase deploy --only firestore:rules --project chorejar-liisgo-2026.48 smoke checks cloud aprobados con cuentas sintéticas limpiadas; incluye selección infantil, visibilidad padre, bloqueo de dinero, hermano y asset arbitrario.23 tests locales aprobados; flutter analyze limpio.
Imagegen integrado produjo peluche, patineta y tableta transparentes en3 llamadas, inspeccionados visualmente. Originales copiados a design/source-images/{teddy,skateboard,tablet}.png. Generados exec-a68d17c9-fa8a-453d-b9f3-09937ac2bf0e.png, exec-7c755d8e-b677-4efd-8424-913f83c45587.png y exec-44d8fe55-6f42-4c7f-89b5-1532df05b78f.png bajo /Users/juanpolanco/.codex/generated_images/01a118d9-c838-7da2-b47b-b89af8ed75b9. Prompt común: Create one square app savings goal asset [subject]. Beautiful polished soft 3D toy product illustration, rounded forms, soft studio lighting, friendly premium children app aesthetic. Single isolated object centered with generous padding, no text, no logos, no scenery. Actual transparent background. Subjects: a cute honey brown teddy bear with a mint bow sitting upright; a lavender skateboard with mint wheels in attractive three quarter view; a slim lavender tablet with a cheerful pastel rainbow screen in three quarter view.
Optimizador sharp actualizado para regenerar todos los WebP384px, transparencia conservada. Total biblioteca263300bytes, nuevos recursos62078bytes; originales fuera del bundle. Catálogo8 opciones incluyendo Otro regalo, traduccionesES/EN. Compilaciones de demos padre, inicio y niño en curso; se preservan rutas y pestañas previas.
Final: builds parent17.2s, welcome19.2s y niño18.0s exitosos; rutas preservadas (copia raíz sin --delete). Catálogo8 opciones verificado en Mi meta/Editar meta del niño, sin guardar ni alterar elección existente del usuario. Captura outputs/metas-ampliadas.png y pestaña entregable abierta. No build nativa. Generación con skill imagegen integrado; originales conservados.

## 2026-10-10 — tenis, alcance de diez opciones pendiente
Usuario: «shoe o sneaker a least 10». Pregunta pendiente: diez metas en total incluyendo tenis, o diez modelos de tenis. Trabajo independiente: imagen de par de tenis blancos/lavanda/menta generada con imagegen, transparente, estilo3D, sin marca ni texto; inspeccionada y original copiado a design/source-images/sneakers.png. Fuente exec-e190a4a6-e8ec-42df-8a3e-49917bb03784.png en directorio generated_images del chat. Prompt: Create one square savings-goal app asset: an adorable pair of stylish white sneakers with pastel lavender panels and mint accents, softly rounded chunky soles, arranged together in a clear three-quarter product view. Beautiful polished soft 3D toy product illustration, friendly premium children's app aesthetic, soft studio lighting. Single pair centered with generous padding, no brand logos, no text, no scenery. Actual transparent background. Catálogo y reglas sin modificar todavía; pendiente precisar cantidad y completar integración.

## 2026-10-10 — diez metas adicionales (18 opciones totales)
Usuario aclaró que quiere diez artículos adicionales, no diez tenis. Se amplía catálogo con sneakers, backpack, soccer, camera, guitar, robot, blocks, scooter, watch y artkit, conservando las8 opciones previas. Tenis usa original de turno anterior; nueve ilustraciones nuevas generadas individualmente con imagegen integrado, fondo transparente y estilo3D pastel, originales conservados. Rutas de fuentes en design/new-goal-sources.json. Prompt común: Create one square savings goal app asset: [subject]. Beautiful polished soft 3D toy product illustration, rounded forms, friendly premium children's app aesthetic, soft studio lighting, lavender mint and cheerful pastel accents. Isolated centered object or compact set with generous padding. Actual transparent background. No text, no logos, no scenery.
Sujetos: a cheerful mint and lavender school backpack; a classic white and turquoise soccer ball; a cute pastel pink instant camera; a small honey wood acoustic guitar with mint accents; a friendly mint and white toy robot; a colorful toy building brick castle; a lavender kick scooter with mint wheels; a pastel blue smartwatch with a simple star on the screen; a neatly arranged little watercolor paint palette with two brushes and colored pencils.
Selector limitado a340px con desplazamiento y pista textual; controles del formulario quedan fuera de la galería. TraduccionesES/EN y lista permitida Firestore actualizadas. Reglas desplegadas correctamente;58 smoke checks cloud aprobados, incluyendo cada nuevo ID seleccionable por niño y límites de permisos, cuentas sintéticas limpiadas. Análisis inicial limpio. Presupuesto biblioteca ajustado de300 a500KiB por los10 artículos adicionales y test exige18 opciones. Generación/optimización y validación final en curso.
Ilustraciones terminadas e inspeccionadas. Diez originales adicionales archivados, recursos WebP384px generados con optimizador existente. Total final477698bytes para toda la biblioteca. Primer intento de pruebas falló por disco lleno; borrado rm-f de cachés rechazado automáticamente por política de comando, resuelto con flutter clean (limpieza específica oficial) + flutter pub get. No se borraron datos, originales ni previews. Segundo intento24tests aprobados; warning de hit-test en selector corregido afinando target a ChoiceChip y esperando render. Repetición dirigida y builds en curso. Análisis previo sin incidencias,58 pruebas cloud aprobadas.
Cierre: test dirigido de galería aprobado sin warning; builds parent14.9s, welcome14.2s, niño15.8s correctos y previews sincronizadas conservando subrutas. Nueva pestaña infantil propia requirió una recarga por SW anterior, sin tocar borradores de otras pestañas.18 opciones confirmadas por árbol accesible y galería desplazada visualmente a tenis/mochila/balón/cámara/guitarra en440×956. Captura outputs/diez-metas-nuevas.png, pestaña entregable abierta. No cambios a meta guardada del usuario ni build nativa.


## 2026-10-11 — versiones nativas de prueba 1.0.0 (1)
Usuario autorizó preparar Android/iOS con el icono v2. Disco interno inicialmente209MiB; compilaciones aisladas en /Volumes/Mac2TB/ChoreJarBuilds/2026-10-11/source, copiando fuente sin build/.dart_tool/work/Pods/.gradle. Gradle y CocoaPods usan cachés externas. JBR21 de Android Studio, Flutter3.38.7, Xcode27.0. Nombre visible iOS normalizado a ChoreJar; Podfile.lock actualizado con resolución nativa. No modificaciones a otros proyectos ni al simulador iPhone Duo.
Android flutter build apk --release --split-per-abi correcto238.6s: ARMv7 19.1MB, ARM64 21.4MB, x86_64 22.8MB; firma debug de prueba existente, no firma Play Store. Copias con nombres legibles en releases/ del directorio externo. Emulador exclusivo ChoreJar_Test API36 creado con datos externos; APK ARM64 instalado con Success y arranque frío Status:ok. Log confirma inicialización Firebase por opciones Dart (warning inicial de proveedor sin opciones nativas no impide inicialización explícita posterior). Enlace sintético sin canje chorejar://join-parent?code=00000000000000000000000000000000 entregado a MainActivity y recibido por app_links. CUA no reconoce el ejecutable qemu como app; estos checks no equivalen a validación visual o canje real.
Primera compilación iOS interrumpida intencionalmente para redirigir DerivedData al disco externo; Xcode generaba cachés internas pese a BUILD_DIR externo. Reanudada con xcodebuild -derivedDataPath externo y -jobs4. Build web previo y DerivedData correspondiente a esta copia archivados en el disco externo para liberar espacio, sin borrar datos ni previews. Firma/despliegue iOS aún en curso.

Cierre nativo: xcodebuild Release con DerivedData externo terminó BUILD SUCCEEDED. codesign --verify --deep --strict correcto. Bundle com.liisgo.chorejar, ChoreJar,1.0.0(1), mínimo iOS15; perfil de desarrollo incluye iPhone JP y vence2027-02-10. devicectl confirmó instalación y lanzamiento en iPhone físico JP. IPA de desarrollo empaquetada con Payload/Runner.app en releases; no archive/TestFlight ni distribución pública.
APK ARM64 verificado con apksigner (Android Debug); aapt confirmó appID,nombre,minSDK24,target36,ABIarm64. Por split-per-abi versionCode2001 paraARM64 (base1); versión visible1.0.0. Icono comprimido de APK coincide píxel por píxel con PNGv2 (los bytes difieren por recompresión PNG). Reinicio Android Status:ok. No prueba visual nativa ni canje/hoja de compartir completos: CUA no reconoce qemu y DeviceHub devuelve timeout. Pruebas funcionales cloud/locales de turno anterior se mantienen, no se presentan como ejecutadas de nuevo.
Guía de instalación/recorrido manual y SHA256 de4paquetes en releases. README actualizado. No cuentas reales ni datos de familia alterados, sin publicación en tiendas.

Corrección de arranque iOS: el lanzamiento inicial informado por devicectl terminaba de inmediato; el único Runner vivo pertenecía a otra instalación. Verificado usando la ruta exacta del contenedor, no solo nombre de proceso. Crash de ChoreJar SIGTRAP en ___UIApplicationEvaluateRuntimeIssueForNoSceneLifecycleAdoption_block_invoke. Consultada guía oficial https://docs.flutter.dev/release/breaking-changes/uiscenedelegate; Xcode27/iOS27 exige UIScene. Adaptados AppDelegate.swift a FlutterImplicitEngineDelegate con registro en didInitializeImplicitFlutterEngine, e Info.plist a FlutterSceneDelegate/Main con escena única. APIs presentes en Flutter3.38.7. Cambios aplicados tanto a fuente original como copia externa.
Rebuild incremental BUILD SUCCEEDED, firma verificada, reinstalación en iPhoneJP correcta. Console permanece adjunta sin terminación; proceso4093 coincidió exactamente con nuevo contenedor4C2F5975. URL sintética entregada por devicectl --payload-url, sin canje; reinicio normal para dejar onboarding. IPA reemplazado, hashes regenerados y guía actualizada. La validación visual y los flujos de cuenta completos siguen pendientes de prueba manual.


## 2026-10-11 — punto decimal y coma de miles
Solicitud: mostrar12.50 y1,000.00 en lugar de12,50. money() usa formato numérico en_US con código de moneda al final; childCash comparte moneyLocale en_US, conservando símbolos y formato compacto. La precisión propia de cada moneda (0/2/3decimales), los saldos y el parser de entrada no cambian. Versión de prueba incrementada a1.0.0+2.
10pruebas dirigidas aprobadas (formato, ledger/parseo y pantalla infantil), incluyendo español/inglés,0,12.50,1,000.00,DOP,JPY,KWD,negativos y compacto; flutter analyze sin incidencias. Parent/child/welcome web recompilados. Captura y AX confirman12.50 USD,33.00 USD,57.00 USD.
El disco interno se llenó durante rsync: preview propio trasladado a /Volumes/Mac2TB/ChoreJarBuilds/2026-10-11/web-preview y enlazado desde work/child-preview; sincronización reanudada correctamente sin borrar subrutas. Servidor8318 reiniciado; no se recargó la pestaña original con posibles datos del usuario. Nueva pestaña entregable money=decimal-point. iOS build2 compilado y firmado; instalación y Android en curso.

Cierre:3APK release build2 correctos74.6s, ARM64 instalado con -r Success. iOS build2 instalado correctamente, iniciada app sin borrar datos.4paquetes reemplazados y hashes actualizados. Prueba visual web guardada outputs/importes-con-punto.png.


## 2026-10-11 — edición sencilla de importes y teclado
Usuario pidió borrar cantidad al tocar campo, teclado numérico y Enter para ocultarlo. Nuevo MoneyInput compartido por editor (mesada,tareas,metas,movimientos) y wizard (primera recompensa). Al ganar foco borra una vez; toques durante la misma edición conservan lo escrito. Teclado decimal, TextInputAction.done y onSubmitted unfocus. Botón persistente Listo/Done dentro del campo cubre teclado decimal iOS sin Enter; solo cierra teclado, no guarda. Controladores y validación de dinero existentes conservados. Versión1.0.0+3.
26pruebas aprobadas y análisis limpio. Prueba nueva verifica borrado al entrar, conservación en segundo toque, tipo decimal, acción done y cierre por botón/Enter conservando texto. Prueba visual detectó refoco cuando se retiraba dinámicamente el botón del suffixIcon: corregido manteniendo el botón estable y eliminando setState del listener de foco. Test dirigido repetido correcto; navegador ahora conserva12.50 y foco queda en Listo.
Previews parent/child/welcome recompilándose con ajuste final; build inicial3 nativo correcto pero se sustituirá por build con botón estable. Caché vieja de traducciones en127.0.0.1 mostró keyboardDone; verificación limpia enlocalhost muestraListo. CDP bypass/cacheDisabled se usaron temporalmente en pestañas propias y se restauraron. No se guardaron cambios en familias reales ni pestaña original del usuario. Captura outputs/cantidad-boton-listo.png.

Cierre: ajuste final compilado en3previews y3APK (34s), instalado ARM64 con Success. Xcode incremental devolvió BUILD SUCCEEDED pero verificación exterior indicó hash obsoleto de App.framework/App (firma interior válida); renovada firma exterior con la misma identidad Apple Development Juan Polanco preservando identificador,entitlements,requirements,flags. Verificación codesign --deep --strict posterior correcta. IPA final regenerado, reinstalación en iPhoneJP correcta (contenedorE7D8B79E), iniciada app. Checksums y guía build3 actualizados. Sin cambios a datos/cuentas reales; pestañas temporales cerradas.


## 2026-10-11 — materiales de publicación y actualización
Creada carpeta /Volumes/Mac2TB/ChoreJar (112.4 MiB), acceso Desktop/ChoreJar. Incluye textos ES/EN para ambas tiendas, 271 traducciones actuales por idioma y CSV, editor local de JSON, iconos nativos/master/Play512, banners bilingües PNG1024x500 y SVG, referencias y plan de capturas, borradores de privacidad/soporte/eliminación, instaladores SOLO PRUEBAS build3, fuente ZIP188entradas y recursos, guías de actualización y publicación con datos pendientes. JSON, claves, enlaces, dimensiones y ZIP verificados; inventario SHA256. Editor probado cargando tienda_es.json, modificando subtítulo y descargando copia confirmada en Downloads; fuente original intacta. Índice servido localmente en8320, funciona también abriéndolo directamente. No se publicaron fichas ni paquetes. Pendientes explícitos: capturas nativas finales, datos y URLs reales, revisión de privacidad/público infantil y firmas/paquetes de distribución.


## 2026-10-11 — monetización inicial (pendiente de cuentas)
Solicitud: banner inferior, rewarded y planes0.99/mes9.99/año. AdMob abierto pero requiere login, pregunta enviada para iniciar sesión y confirmar USD. Integrado google_mobile_ads9.1.0, IDs oficiales de prueba nativos, ADS_ENABLED opt-in y ADS_LIVE false por defecto. Banner inferior solo en área padres por revisión infantil pendiente, separado de navegación y oculto al escribir. No aparece en sesión infantil. Reward voluntario en Ajustes/Plan y anuncios:24h sin banners en este dispositivo, sin modificar ledger, solo callback earned y persistencia local. Clasificación G, ageRestrictedTreatment.child, no personalización; rama live exige UMP canRequestAds y ofrece privacy options. Planes de pago informativos marcados pendientes, sin cobros ni premium ficticio: requieren productos tienda y verificación de suscripción servidor. No se han creado bloques reales, productos ni infraestructura pagada. Fuente1.0.0+4; builds3 anteriores preservados. Materiales actualizados con guía de pendientes y avisos de revisión de privacidad.

Validación: flutter analyze limpio;26tests existentes pasan y3nuevos de monetización pasan tras corregir selector de subtipo FilledButton.icon en prueba. APK ARM64 build4/versionCode2004 compilado correctamente54.5s, firma de prueba verificada, AD_ID eliminado. Copia en materiales con SHA256, fuente ZIP build4 y advertencias actualizadas. iOS aún no recompilado con este SDK; no se verificó visualmente entrega/recompensa del anuncio en dispositivo. AdMob sigue pendiente de login y moneda USD propuesta sin confirmación.

## 2026-10-11 — acceso a Firebase para continuar monetización
Usuario proporciona consola chorejar-liisgo-2026 y autoriza lo necesario. Firebase CLI confirmó proyecto activo y registros ANDROID/IOS com.liisgo.chorejar, coincidentes. Navegador solo tiene cuenta distinta sin acceso al proyecto. functions:list falla sin diagnóstico concreto; no se concluye ausencia de funciones ni estado de facturación a partir de ese error. No se cambió plan de facturación, permisos, reglas o datos. Acceso AdMob y productos/validación de tiendas siguen pendientes; no es necesario recrear Firebase.

## 2026-10-11 — UX compacto y iPhone Duo
Usuario aporta5fotosHEIC del A51, pide reducir tamaño de padres y adaptar niño y Duo. Fotos convertidas solo para inspección, originales intactos. Compacto según ancho<430 o alto<720: márgenes14, encabezados22, navegación64, botón eliminar icono rojo con tooltip y confirmación existente, saldo horizontal compacto, subtítulos redundantes fuera de padres, explicación de mesada desplegable; ajustes conpadding16 y títulos15 manteniendo escalado de accesibilidad. Niño: frasco proporcional con mínimo130, saldo48 en poco espacio, cerdito62, ahorro19 y navegación compacta. Sin cambios de datos ni anuncios reales.
29tests pasan, análisis limpio. Ampliada matrizES/EN a360x640,384x760,411x731 y Duo466x678/669x951/951x669;320x568 con texto2x preservado. DimensionesDuo obtenidas de capabilities.plist del simulador instalado. Verificación visual web360x640 y466x678 confirma balance, frasco y ahorro; ajustes legibles. APK ARM64 build5/versionCode2005 listo, anuncios de prueba. Preview propia8322, sin alterar pestañas anteriores. Compilación iOSsim en curso.

Cierre build5: ajuste final ancho430 verificado con7tests dirigidos. iOS compilado con éxito para arm64 en Duo; Flutter intento universal fallaba detectando arquitecturas y Xcode detectó header beta no modular del SDK Ads. Debug/Release.xcconfig permiten ese header; build xcodebuild arm64 exit0. Instalado en Duo B95F7428-D395-4B76-8E34-5F622AA77D80, arranque y wizard local Prueba Duo verificados, panel padre con banner Test mode y pantalla infantil sin banner correctos. Capturas en materiales. No se probó hardware físico A51/Duo ni compra/reward completo en iOS.

AdMob: sesión ahora disponible. Creadas apps ChoreJar Android/iOS no publicadas y cuatro bloques banner/rewarded; todos confirmados. IDs en store/admob-production-ids.json y materiales. No activados en binarios; aún requieren tiendas/revisión y configuración privacidad. Suscripciones pendientes, sin cobros. Materiales y ZIP build5 actualizados.

## 2026-10-11 — IDs Android proporcionados por el usuario
IDs Android definitivos: app ~2231725246, banner /2830491048, rewarded /9044545602 (publisher8588489900323524). Se conservan IDs iOS. Registro y materiales sincronizados; APK y configuración de pruebas intactos. Los bloques Android creados previamente no se borran; su captura es histórica. No se verifica aprobación ni activación a partir de IDs proporcionados.

## 2026-10-11 — IDs iOS proporcionados por el usuario
IDs iOS definitivos: app ca-app-pub-8588489900323524~8335108326, banner ca-app-pub-8588489900323524/7292480235, rewarded ca-app-pub-8588489900323524/7162372313. Android conservado. Registro, materiales y ZIP sincronizados; binarios y anuncios de prueba intactos. Bloques anteriores no eliminados; captura iOS histórica. IDs recibidos no prueban aprobación ni activación de producción.


## 2026-10-11 — punto de continuidad al cerrar la sesión
Solicitud del usuario: «deja todo grabado en el documento para ti». Este resumen describe el estado vigente y complementa el historial anterior. El alcance inicial sin publicidad fue modificado posteriormente por petición explícita del usuario.

### Proyecto y preferencias confirmadas
- Fuente activa Flutter: /Users/juanpolanco/StudioProjects/ChoreJar. Workspace del chat: /Users/juanpolanco/Documents/Codex/2026-10-07/chore. No confundir con otros proyectos del usuario. Sin repositorio Git en esta carpeta.
- ChoreJar en inglés / Mi Mesadita en español. UI sencilla para padres con poco conocimiento tecnológico; conservar estilo infantil de frasco, monedas, cerdito e ilustraciones. Biblioteca ligera de metas y selección infantil existente.
- Importes con punto decimal y coma para miles; campos monetarios borran al entrar en edición, teclado decimal y botón Listo para ocultarlo.
- Eliminar niño con icono rojo al extremo derecho del nombre y confirmación. Acceso de segundo padre mediante invitación sencilla. Mantener wizard inicial.
- Última versión fuente: 1.0.0+5. No interpretar estos apuntes como publicación en tiendas ni como aprobación comercial.

### UX y entregables actuales
- Padres compactos: márgenes y tipografía reducidos, saldo horizontal, menos contenido repetido, detalles de mesada desplegables. Criterio general ancho<430 o alto<720; escalado de accesibilidad conservado.
- Niño: frasco, saldo, tarjeta de ahorro y navegación adaptativos. Fotos A51 recibidas IMG_7081–7085. No se probó físicamente ese teléfono; se revisaron capturas, tamaños lógicos y pruebas de layout.
- 29 pruebas completas aprobadas y análisis limpio; 7 pruebas dirigidas repetidas tras el ajuste final a430. Matriz incluye320x568 con texto2x,360x640,384x760,411x731 y tamaños Duo466x678/669x951/951x669.
- APK ARM64 de prueba actual: /Volumes/Mac2TB/ChoreJar/06_Instaladores_SOLO_PRUEBAS/ChoreJar-build5-pantallas-pequenas.apk (versionCode2005), con checksum. Los IDs definitivos recibidos después NO cambian ese binario.
- iOS simulador compilado e instalado en Duo B95F7428-D395-4B76-8E34-5F622AA77D80. Verificados arranque, wizard local «Prueba Duo», panel de padres con banner Test mode y niño sin banner. No es validación en iPhone físico ni un IPA de distribución build5.
- Fix iOS: Debug/Release.xcconfig permiten CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES por header beta de Google Mobile Ads. Build universal Flutter falló en detección de arquitecturas; xcodebuild explícito arm64 completó con éxito. Logs en /Volumes/Mac2TB/ChoreJarBuilds/2026-10-11/duo-build.txt.
- Preview web local propio: http://127.0.0.1:8322/ (comprobar servidor al retomar). Materiales: /Volumes/Mac2TB/ChoreJar, acceso Desktop/ChoreJar; índice local8320 cuando servidor activo. Capturas Duo en04_Capturas.

### Anuncios: configuración definitiva recibida del usuario
Los IDs autorizados para futura producción son los siguientes; no son credenciales secretas. Fuente de verdad: store/admob-production-ids.json.

ANDROID:
- app_id: ca-app-pub-8588489900323524~2231725246
- banner: ca-app-pub-8588489900323524/2830491048
- rewarded: ca-app-pub-8588489900323524/9044545602

IOS:
- app_id: ca-app-pub-8588489900323524~8335108326
- banner: ca-app-pub-8588489900323524/7292480235
- rewarded: ca-app-pub-8588489900323524/7162372313

- Estos sustituyen los cuatro bloques creados anteriormente por el asistente. No borrar ni usar los antiguos por accidente. Capturas AdMob-Android-creados.jpg y AdMob-iOS-creados.jpg son evidencia HISTÓRICA de los bloques anteriores, no de los IDs finales enviados por el usuario.
- IDs guardados en proyecto y materiales; no se ha comprobado aprobación de los nuevos IDs en AdMob. SDK nativo sigue con IDs de prueba. ADS_ENABLED activa integración; ADS_LIVE=false por defecto. No afirmar que los anuncios reales están activos.
- Banner inferior solo en padres, separado de navegación y oculto al escribir. Reward voluntario en Ajustes > Plan y anuncios: 24h sin banners EN ESE DISPOSITIVO, solo tras callback earned; nunca dinero ni cambios al saldo del niño. Flujo completo de recompensa iOS aún no verificado visualmente.
- Tratamiento infantil, clasificación G, solicitudes no personalizadas y UMP en rama live; no bastan por sí solos para certificar aprobación de tiendas.

### Pendientes reales para continuar
1. Recibir resultado del APK en A51 físico y ajustar únicamente problemas observados.
2. Antes de producción, verificar apps/IDs finales y vinculación con tiendas, revisión AdMob, mensajes de consentimiento, declaraciones de anuncios y privacidad infantil. Configurar APP IDs nativos y dart-defines de producción juntos; mantener binarios de pruebas seguros.
3. Suscripciones0.99 mensual/9.99 anual: propuesta informativa, USD pendiente de confirmación. No hay productos de tienda, compras nativas, restauración ni verificación de recibos/entitlements de servidor. No se cobra ni se prometen derechos Premium ya funcionales.
4. Materiales de publicación siguen borradores: contactos/URLs reales, privacidad/Data Safety y capturas finales de tienda pendientes. No subir IPA/APK de prueba como producción. Firebase chorejar-liisgo-2026 con com.liisgo.chorejar; no se cambió facturación ni se habilitó infraestructura de cobro.
5. Revisar PROJECT_LOG.md y estado real de archivos/servidores al retomar. No depender de memoria del chat, no modificar otros proyectos ni borrar datos del usuario.

### Guardado de esta petición
Se leyeron registro y JSON vigentes; se añadió este resumen preservando todo el historial. Actualizada copia del registro en materiales, entrada PROJECT_LOG.md del ZIP build5 e inventario SHA256; ZIP y JSON comprobados. No se modificó código ni se recompiló: esta petición es de documentación. Operaciones ejecutadas mediante lectura/escritura Python pathlib, zipfile para actualizar y comprobar ZIP, hashlib/csv para inventario; inspección inicial con ls/rg/cat. Sin contraseñas, tokens ni claves privadas en este resumen.

## 2026-10-11 — Duo estrecho y ancho
Usuario pide contemplar narrow y wide. Implementado layout por ancho disponible (>=640) y texto <=1.5x: padre perfil/controles a izquierda y sección activa derecha; niño Mi dinero frasco izquierda y saldo/recompensa/ahorro derecha. Estrecho o texto grande conserva columna única. Anchura máxima1100 padre/1000 niño, sin escalar toda la interfaz. SafeArea y navegación existentes preservadas. surfaces.dart, dashboard.dart y child_money.dart actualizados. Pruebas de redimensionamiento466→669→951→466 mantienen sección y saldo;7tests dirigidos aprobados y análisis limpio. Fallo inicial del test por ensureVisible sobre elemento aún no construido resuelto con scrollUntilVisible. Compilación e instalación iOSsim arm64 correctas; build5 permanece número de desarrollo, APK anterior NO incluye este último ajuste. Binarios siguen anuncios de prueba; IDs definitivos sin cambios. Preview parent recompilada en8322.

Cierre visual: preview web confirma padre en dos columnas951x669 y niño en dos columnas951x669; vuelta a466x678 conserva saldo y pantalla y muestra columna única. Capturas Duo-wide-padre/Duo-wide-nino/Duo-narrow-nino en04_Capturas. No se completó cambio físico de estado del simulador porque el usuario estaba interactuando con Device Hub; validación visual de anchos realizada en navegador y por tests. ZIP actualizado; APK entregado previamente sigue siendo build5 anterior al ajuste Duo.

## 2026-10-11 — compartir vínculo infantil por mensaje, QR y código (build6)
Usuario pide enviar por texto y opción barcode/otras para teléfono o tableta quizá soloWi-Fi. Implementado diálogo con share_plus existente (selector nativo, anclaje iPad, sin envío automático), QR local qr_flutter4.1.0/qr3.0.2 y código copiable. Ayuda ES/EN: internet en ambos dispositivos, no SIM/número ni misma red; app instalada y fallback manual si cámara/enlace no abre. QR usa chorejar://join-child?code=…; no escáner interno ni permiso de cámara, usa cámara del sistema.
ChildInvitation parser valida token32hex y ruta exacta, rechaza enlace de padre. CloudRepository.pair acepta código/enlace/mensaje mediante parser; reglas, token aleatorio, expiración10min y usoúnico existentes intactos. Android añade host join-child; iOS ya registra esquema chorejar. AppLinks enruta al formulario infantil precargado, separado del formulario segundo padre, y aún exige pulsar Vincular. Campo permite mensaje/enlace completo, pegar y tecladoDone.
Archivos: nuevos services/child_invitation.dart, widgets/child_invitation_dialog.dart, main_link_preview.dart (soloQRfalso), test/child_invitation_test.dart; modificados dashboard,sign_in,welcome_flow,main,repository,AndroidManifest,ES/EN,pubspec+lock. Dependencia QR documentada en https://pub.dev/packages/qr_flutter. Versión1.0.0+6, IDs reales y ADS_LIVE=false sin cambios.
Validación:32tests completos aprobados, flutter analyze limpio. Pruebas nuevas cubren parser/rutas, apertura infantil sin campos de padre y diálogo320x568 texto2x/tabletasESEN. Primer intento de test usaba getter privado inexistente del paquete: corregido. Test de layout detectó intrinsicSize de LayoutBuilder dentro de QR/AlertDialog: corregido con SizedBox.square dimensionado. Preview web8323 compilada y revisada360x740; capturaVincular-nino-QR-prueba.jpg sin token real. iOSsim arm64 compiló exit0; no se instaló durante interacción del usuario con Device Hub. Androidrelease en curso. No se enviaron SMS, no se probó enlace completo entre dispositivos físicos ni se modificaron familias reales.

Cierre build6: APK releaseARM64 compilado180.6s inicialmente y recompilado final tras ajuste QR con exit0. Copiado ChoreJar-build6-vincular-QR.apk+SHA256 a materiales; incluye cambios Duo y vinculación. iOSsim compila, pero no es IPA para teléfono. Nueva fuenteZIPbuild6, traduccionesCSV/JSON y guía VINCULAR_NINO actualizados. No se activaron anuncios reales ni se enviaron mensajes.

## 2026-10-11 — confirmación explícita del uso de IDs
El usuario reitera que ni siquiera al pedir APK se deben usar anuncios reales; solo cuando se mande a tienda. Guardada regla al inicio de este registro y en materiales/JSON. Verificado en fuente: ADS_LIVE falso por defecto, banner/rewarded oficiales de prueba y APP IDs Android/iOS oficiales de prueba. No se cambió código ni binarios; no fue necesaria recompilación.

## 2026-10-11 — corrección pendiente del ancho nativo Duo
Usuario reporta que Duo solo muestra formato alto. Inspección nativa confirmó margen negro de compatibilidad; giro funciona pero persiste espacio reservado. Fuente Info.plist ya admite portrait y landscape, escena Flutter usa FlutterSceneDelegate y familias1,2. Binario actual DTSDKName=iphonesimulator27.0 y único Xcode instalado /Applications/Xcode.app27.0(27A266a), SDK27.0. Búsquedas mdfind y ubicacionesApplications/Downloads/Mac2TB no encontraron versión nueva; ruta Xcode-beta del inventario DeviceHub es obsoleta.
Apple oficial https://developer.apple.com/iphone-duo/prepare/ distingue SDK27.0 (evita franja de estado) y27.1+ (pantalla completa). Por tanto validación web anterior NO probaba modo nativo completo: no afirmar listo hasta instalar/compilarSDKnuevo y comprobarDuo. Usuario AUTORIZÓ instalar Xcode por separado para no afectar otros proyectos. Mantener Xcode27.0, no cambiar xcode-select global.
Abierta descarga oficial https://developer.apple.com/download/all/?q=Xcode en pestaña22; Apple requiere login. Se pidió al usuario iniciar sesión allí sin compartir contraseña/OTP. Esperando login; NO se descargó ni instaló aún. macOS27.0.1, disco interno95Gi disponibles, externo1.2Ti. Nuevo tool/build_duo_test.sh exige SDK>=27.1 y APPIDdeprueba, configura ADS_ENABLED=true/ADS_LIVE=false y compila arm64sim con DEVELOPER_DIR local. bash -n correcto y ejecución conSDK27.0 aborta como previsto antes de cambiar build. Script completo pendiente de validar conSDKcompatible.

## 2026-10-11 — instalación separada de Xcode27.1 RC
El usuario completó login Apple y confirmó continuar. Descargado Xcode27.1 Release Candidate desde developer.apple.com (publicado5oct2026), extraído en /Volumes/Mac2TB/DeveloperApps/Xcode-27.1-RC/Xcode.app. xcodebuild reporta27.1(27A9275), codesign --verify --deep --strict y checkFirstLaunchStatus finalizan0. No se sustituyó /Applications/Xcode.app27.0 ni se cambió xcode-select global. Compilación tool/build_duo_test.sh en curso con DEVELOPER_DIR local, SDK27.1 y ADS_LIVE=false; log /Volumes/Mac2TB/ChoreJarBuilds/2026-10-11/duo-sdk27.1.log. Nuevo DeviceHub muestra Closed/Partially Open/Open.
Login padre autorizado probado mediante interfaz nativa: campos recibieron entrada, pero Firebase devolvió mensaje genérico «Could not sign in. Check your email and password». No afirmar que la contraseña es incorrecta: UI agrupa errores de autenticación. No se creó cuenta ni se restableció contraseña. No guardar credenciales en documentos/código/ZIP. Se continúa validación visual en vista local existente Prueba Duo.

Cierre Xcode27.1: tool/build_duo_test.sh completó BUILD SUCCEEDED (exit0). Info.plist del binario confirma DTSDKName=iphonesimulator27.1, DTXcode2710, bundlecom.liisgo.chorejar, build6 y APPIDoficial de prueba. Generated.xcconfig confirma ADS_ENABLED=true, ADS_LIVE=false. Instalado sobre el mismo Duo B95F7428-D395-4B76-8E34-5F622AA77D80 sin borrar datos.
Validación NATIVA completada en DeviceHub27.1: franja negra lateral del SDK27.0 desaparece, fondo abarca pantalla completa; padre abierto/horizontal en dos columnas; niño Mi dinero abierto/horizontal frasco izquierda y saldo/ahorro derecha; Duo cerrado y vertical usa columna única; cambio de tamaño conserva sección/saldo. Banner padre muestra Test mode; niño sin banner. Datos de prueba local existentes Prueba Duo conservados. Capturas Duo-nativo-SDK27.1-{padre,nino}-{ancho,estrecho}.png en04_Capturas. No es validación física ni IPA de distribución; Android/APKbuild6 no cambió. No se modificó código Flutter durante esta instalación.
La cuenta real de padre NO quedó iniciada: fallo genérico de autenticación; no crear/resetear cuenta sin indicación del usuario. Xcode predeterminado sigue /Applications/Xcode.app/Contents/Developer. Repetir build pasando ruta nueva al script; discoMac2TB debe estar conectado. Materiales, ZIP fuente e inventario actualizados.

## 2026-10-11 — revisión UX/UI y navegación visible (build7)
Usuario no encuentra Ajustes/vinculación y pide revisar UX/UI completo. Problemas constatados: iconos sin etiqueta(tune/ellipsis), vínculo escondido en hoja larga, preview8323 soloQR sin app, modo local terminaba en errorcloudOnly. Cambiado a botón visible Ajustes+engranaje, pantalla completa con Atrás y grupos Familia/dispositivos primero, Preferencias, Administrar perfil y Privacidad. Acceso Vincular dispositivo directamente bajo perfil infantil; diálogoQR identifica niño. Modo local explica límite y lleva directamente a login mediante Dashboard.onAccount/WelcomeFlow.initialMode, sin inventar tokens ni migrar datos.
Fallo funcional detectado y corregido: parentAccess mantenía run/busy activo mientras dialog esperaba otro run al invitar/remover. Lectura de segundo padre termina antes de presentar acciones; prueba contra repositorio Cloud falso confirma generación de invitación. run permite success:null para lecturas/apertura sin mensaje genérico de éxito. Rol infantil/preview ya no expone eliminación de cuenta del padre; otras opciones familiares y planes solo padres. Preferencias infantiles no repiten avisos ni ofrecen cuenta de padre. Inicio infantil recibe encabezado/esquema de ayuda propio. SignIn muestra/oculta contraseña y Done; distingue errores de red/intentos/operación no permitida, sin registrar credenciales. Planes usan SafeArea/max720 de pageBody. ES/ENactualizados; versión1.0.0+7.
Validación final36tests aprobados+flutter analyze sin incidencias. Nuevos tests settings_navigation cubren acceso visible, modo local sinQR, salto directo aSignIn, vínculo al niño seleccionado, controles infantiles y regresión segundo padre; ambosidiomas,320con2x,384y951. Pruebas iniciales fallaron por localizadores sin desplazar contenido construido perezosamente y pageBack asumiendo tooltipinglés: ajustados aensureVisible/scroll yBackButton; se conservan verificaciones de comportamiento, no se silencian fallos. Test adicional de diálogo segundo padre320/2x pasó al desplazar su control antes de tocarlo. Revisión visualweb384x760 yDuo nativo27.1 abierto/cerrado enES/EN, anuncios Testmodepadre/ninguno niño. Fuente, APK, capturas y reporte REVISION_UX_UI_BUILD7.txt se guardan en materiales.
No se reintentó autenticación real, no hubo envío de mensajes ni cambios a familias remotas. Link real entre equipos físicos yA51físico siguen pendientes. Todas las compilaciones ADS_LIVE=false; no se tocó Xcode global. Preview completo nuevo8324; pestaña delQR8323 redirigida a8324 para no confundir demo con app.

Cierre build7: web compilada8324; iOSsimSDK27.1/build7 compila e instala; AndroidARM64split versionCode2007 compila. Comparada firmaAPKconbuild6: mismo certificado, permite actualización sin desinstalar. APP IDsdeprueba verificados enAPK yRunner; ADS_LIVE=false verificado enconfig. Primero se generó un APKunsplit versionCode7 inferioral2006: NOentregado; recompilado consplit-per-abi para2007. APKfinal ChoreJar-build7-ajustes-vinculacion.apk conSHA256, fuenteZIPbuild7, textosCSV/JSON yreporte UX actualizados. No datos reales alterados; usuario puede seguir usando familias locales existentes.


## 2026-10-11 — A51 compacto, HTTPS y recuperación de vinculación (build8)
Usuario aporta fotos A51 y fallo real de QR/iPhone. APK1.0.0+8 ARM64 versionCode2008. Dashboard compacto agrupa acciones en Perfil, evita selector redundante con un niño, conserva borrar derecha y Vincular visible; tareas16, fechas cortas, paneles12, saldo compacto, mesada0sin configurar oculta. SafeArea común para navegación/banner. Se respeta texto ampliado; no clamp global.
Invitaciones ahora HTTPS en https://chorejar-liisgo-2026.web.app/join-child#code=TOKEN (padres /join-parent), fragmento no enviado al hosting, texto con párrafos separados, selector SharePlus WhatsApp/SMS/correo. Parser estricto: rutas y host propios, un token32hex, compatibilidad chorejar://; niño rechaza ruta de padres. QR HTTPS; hosting bilingüe publicado con Abrir ChoreJar/Copiar código y errores comprensibles, sin analítica ni envíos externos. Android autoVerify y assetlinks con huella de firma APKdeprueba; dominio VERIFIED. Apple association publicada 3M9854JZ4Y.com.liisgo.chorejar. Proyecto iOS tiene AssociatedDomains; wildcardprofile de test no, por eso IPAusa página+botón de apertura.
Diagnóstico real: claim transaccional infantil terminaba, luego lectura get/listener del SDK devolvía permission-denied. REST y transacción sí autorizaban la misma sesión. No causa interna definitiva del SDK. CloudRepository.resume lee link+perfil en transacción; pair recupera claim ya guardado para el mismo owner/child/accessVersion, rechaza otroperfil, no consume invitación nueva al recuperar sesión existente; vigencia la impone servidor. watch infantil ignora caché; ante permission-denied del listener cancela y lee transacción cada10s; revocación detiene, onCancel libera, Dashboard pausa seguimiento enbackground y retoma alresumir. Reglas temporales semánticamente equivalentes no resolvieron: restaurada fuente y despliegue EXACTAMENTE política original guardada deployed-before-build8.rules, sin expansión de permisos.
Validación:40testsFlutterPASS+analyzelimpio; testsFakeAsync seguimiento/revocación/cancelación, tamaños360/384/320ytexto2x, códigos/URLs/mensaje. RESTcloud58PASS. ProbeSDK temporal enFirebaseREAL completa creaciónpadre/invite, pair, watch, retrymismocode, metainfantil, invitaciónnueva mismoperfil recupera, actualizaciónpadre llega, revoke bloquea, retryrevocado falla, cleanupDONE. No familias reales modificadas ni credenciales de usuario utilizadas. Probe test_support/pairing_probe.dart no compila como app principal. Captura QA-build8-vinculacion.png contiene solo resultados sintéticos.
Builds ADS_ENABLED=true ADS_LIVE=false, APP IDs oficialesdeprueba; realesguardados y dormidos. APK firmado igualbuild7, version2008, instalado-r emulador Samsung_A51_Test emulator-5554. A51físico no conectado: pruebas visualweb384x800 + widgets; no afirmar prueba física. Captura UX-build8-padre-384x800-web.png. No envío a contactos ni verificación física de escáner/selector de todaslasapps.
iOSSDK27.1RC separado, xcode-selectglobal sin cambios. pod install --repo-update resuelve índice desactualizado con versioneslock. Firmado IPA desarrollo mediante tool/build_ios_local_test.sh usando perfil wildcard existente del dispositivo registrado, sin nuevas cuentas Apple. CodesignverifydeepstrictPASS; CFBundleVersion8; APPIDsample. Instalado sobre iPhoneJPconectado via devicectl, sin borrar datos; no interactuado físicamente para login. Perfil no habilita UniversalLinks: apertura vía páginaweb y chorejar:// válida en pruebas. Antesdetienda perfildedicadoAssociatedDomains y huellaPlayAppSigning requerida.
DuoSDK27.1 compilado/instalado. Herramienta build_duo_test.sh ahora aplica ad-hoc entitlements con identidad de app/keychain a bundle simulador: el anterior sinfirma causaba FirebaseAuth -34018 enlogs. Firma de simulador verificada; esto no cambia IPAfísico ya firmado con keychain. Vista compacta infantil observada; el control automatizado DeviceHub no activó fielmente algunos controles, no atribuir prueba visual completa de flujo nativo a esos clics.
Materiales: ChoreJar-build8-A51-vinculacion.apk, ChoreJar-build8-vinculacion-ios.ipa, SHA256, reportebuild8, VINCULAR_NINO, l10n/CSV, PROJECT_LOG, fuenteZIPbuild8 e índice. Las capturas sintéticas de render tenían un fallbackAhem defectuoso en Settings y se movieron a QAdebug fuera de materiales; no es evidencia de fallo nativo. Pendiente: prueba física A51 y vinculación entre equipos usuario; tiendas/suscripciones siguen pendientes, nunca usar anuncios reales para APKdeprueba.

## 2026-10-12 — Progreso de meta y solicitud de retiro (build9)
Usuario reporta que la barra de meta no se actualiza y pide retiro desde la app infantil. La causa es que la barra usaba solamente `savings`: cuando el padre registra una entrega, el dinero queda `available`, por lo que la meta seguía en cero. Ahora usa `goalMoney = available + savings` en la vista infantil y de padre. Las tareas pendientes siguen fuera hasta que el padre registra que entregó el dinero; no se muestra como dinero que el niño ya tiene.

El niño puede tocar Pedir retiro en su meta cuando existe dinero para ella. La solicitud contiene el total actual de la meta y no modifica saldos. Aparece en la app del padre con explicación, Cancelar y Confirmar. Solo al confirmar, se registra `cashout`, baja el progreso y queda en Historial. El niño no puede aprobar, mover ni gastar dinero desde su dispositivo. Firestore permite exclusivamente actualizar el campo entero positivo `cashOutRequest` del niño vinculado; los cambios de saldo siguen requiriendo al padre. Reglas compiladas y desplegadas en chorejar-liisgo-2026.

Versión1.0.0+9/versionCode2009. flutter analyze limpio y 41 pruebas completas aprobadas, incluidas las pantallas infantiles320/360/384, texto ampliado, progreso y solicitud, y reconciliación de retiro. APK ARM64 release e IPA de desarrollo creados con ADS_LIVE=false y APP IDs oficiales de prueba. Firma Android igual a la anterior. Nunca se activaron IDs reales de anuncios.

## 2026-10-15 — nombre regional por país

Usuario solicita que la app use el término familiar de cada país para la asignación y que el nombre visible se adapte al país elegido. Se creó `lib/services/regional_brand.dart`, una sola tabla editable con cobertura para todos los países del selector. Ejemplos: República Dominicana `Mi Mesadita`, España `Mi Paga`, México/Centroamérica `Mi Domingo`, varios mercados sudamericanos `Mi Mesada`, Brasil `Minha Mesada`, Japón `こづかいJar`, China `零花钱罐`, Corea `용돈항아리` y Kuwait/Baréin `مصروفي`.

El país de la familia ya se guardaba al crearla; ahora `FamilyRepository` lo expone y `CloudRepository` lo conserva tanto en el registro familiar como en cada perfil infantil nuevo. Así el nombre regional se mantiene en padre, niño vinculado y vistas locales. Las familias o perfiles anteriores sin país infantil obtienen un fallback seguro desde su moneda; una edición posterior del perfil escribe el país de la familia. `SignIn` actualiza el nombre visible de inmediato al escoger país y `Dashboard` lo mantiene después de iniciar. Se añadieron pruebas de cobertura total de países y del cambio Estados Unidos→México=`Mi Domingo` antes de crear la cuenta.

Documentación de publicación y terminología: `store/country-branding.md`. Incluye tabla de nombres, fuentes Cambridge y estrategia real de tiendas. Android puede mostrar nombre/ícono/descripción distintos por país con Custom Store Listings y un solo paquete. Apple puede localizar nombre por idioma/locale, pero no garantizar títulos distintos entre países que comparten exactamente el mismo locale; para eso serían fichas/paquetes distintos. No se publicaron fichas ni se cambiaron nombres de tiendas durante esta tarea.

Validación final: `flutter analyze` sin incidencias y `flutter test` completo con 45 pruebas aprobadas. Bundle actualizado e instalado en simuladores Duo SDK27.1 e iPhone17ProMax para la siguiente revisión visual. IDs reales de AdMob no se tocaron; sigue vigente ADS_LIVE=false para todas las compilaciones de prueba.

## 2026-10-15 — diagnóstico de inicio de sesión

Firebase Console confirma que existe una cuenta de padre por correo, que el proveedor Email/Password está habilitado y que Firebase registró un inicio de sesión exitoso el 15 de octubre. Por lo tanto no se requiere habilitar ni cambiar proveedores de Firebase. Se observaron dos variantes de la contraseña compartidas durante el desarrollo que solo difieren en mayúsculas; las contraseñas de Firebase distinguen mayúsculas y minúsculas. No se reintentó acceso ni se transmitieron credenciales.

Mejora de UX: `sign_in.dart` ahora distingue `invalid-credential`, `wrong-password` y `user-not-found` de errores de red, y muestra un texto claro ES/EN que indica revisar mayúsculas o usar «Olvidé mi contraseña». No se cambió ni restableció ninguna contraseña. `flutter analyze` limpio y suite completa de 45 pruebas aprobada.

Prueba autorizada posterior: se intentó iniciar sesión en el simulador Duo con el correo y la contraseña proporcionados expresamente por el usuario. Firebase rechazó la credencial. No se expuso, almacenó ni modificó la contraseña, y no se envió un correo de restablecimiento.

## 2026-10-15 — preparación de entrega de producción 1.0.0 (10)

Se preparó la primera entrega pública como versión visible `1.0.0`, build Android/iOS `10`. Se guardaron materiales de tienda en `store_assets/`, con notas de versión y ficha en inglés que describen solo funciones implementadas: perfiles familiares, tareas/mesada, vinculación QR/enlace/código, meta/retiro con aprobación del padre, diseño compacto y nombres regionales. No se declara ninguna suscripción porque la pantalla Plus actual solo explica precios propuestos y no hay StoreKit ni Google Play Billing.

El hosting de ChoreJar incorpora las rutas públicas `/privacy` y `/support`, con contacto publicado del perfil verificado de Google Play. La app enlaza el mismo contacto en su aviso de privacidad. Android release ya no puede firmarse con la clave debug: requiere `android/key.properties` y configura el App ID real de AdMob únicamente para release; Debug conserva el App ID de prueba. iOS usa App ID de prueba en Debug y el real en Release. Las unidades reales se inyectan solo mediante dart-defines de entrega.

Estado antes de la compilación: Google Play Console cuenta con seis apps y ninguna para `com.liisgo.chorejar`; aún no se certificaron declaraciones ni se creó la ficha para evitar afirmar cumplimiento antes de completar Data safety/Families. App Store Connect y Apple Developer no tienen sesión activa. Esta Mac no tiene identidad Apple Distribution, perfiles App Store ni clave de subida Android: por tanto no se generó ni subió un binario de producción todavía. El proyecto no tiene repositorio Git ni remoto configurados.

### 2026-10-16 — preparación de distribución 1.0.0 (build 10)
**Solicitado y autorizado:** preparar y enviar ChoreJar a producción en Google Play y App Store Connect, con publicación automática tras aprobación y anuncios reales solo para estos binarios de tienda.

**Builds verificados:** `flutter clean`, `flutter pub get`, `flutter analyze` (sin incidencias) y `flutter test` (45 pruebas aprobadas). Se generaron un AAB firmado de Android y un IPA de distribución de iOS. Ambos corresponden a `1.0.0` / build `10`; Android usa `versionCode 10` y el IPA usa `CFBundleShortVersionString 1.0.0` y `CFBundleVersion 10`. El IPA contiene únicamente Runner, por lo que no hay extensiones con versiones que puedan causar ITMS-90473. La configuración de release habilita los IDs reales de AdMob exclusivamente para el envío de tienda; desarrollo y pruebas continúan usando IDs oficiales de prueba.

**Materiales y privacidad publicados:** se registraron notas y textos en `store_assets/`. Hosting de ChoreJar publica y responde correctamente en `https://chorejar-liisgo-2026.web.app/privacy`, `/support` y `/delete-account`. La página de eliminación refleja el flujo real: Ajustes → Eliminar cuenta, reautenticación y eliminación de cuenta del padre, familia, perfiles infantiles, historial, invitaciones y accesos vinculados; también indica el contacto de soporte sin pedir contraseña.

**Google Play Console:** creada la app borrador ChoreJar para `com.liisgo.chorejar`; política de privacidad, anuncios, Advertising ID, funciones financieras y acceso de revisión fueron configurados. La declaración Data safety se guardó como borrador y declara correo, nombres/apodos, IDs de cuenta, contenido familiar, registros monetarios, ubicación aproximada, diagnósticos, interacciones e IDs de dispositivo; los últimos cuatro se declaran como recopilados y compartidos por Google Mobile Ads para anuncios, analítica y prevención de fraude. No se adjuntó un AAB de producción ni se envió a revisión todavía.

**Bloqueo real de política:** el cuestionario de contenido de Google Play clasifica la función de solicitud de retiro de efectivo como **Cash Rewards** y produce una clasificación ESRB Mature 17+ / PEGI 18. Esa clasificación contradice la audiencia infantil prevista y la experiencia con perfiles de niños. No se guardó una audiencia falsa ni se inició el rollout. Para seguir a Google Play se requiere una decisión del propietario: quitar/rediseñar la función de cash-out y actualizar el binario/metadata, o cambiar formalmente el público del producto a adultos y aceptar las consecuencias de clasificación.

**App Store Connect:** el IPA de distribución se preparó. Transporter tiene una sesión Apple activa, pero Apple respondió que no existe un registro de aplicación accesible para el bundle `com.liisgo.chorejar`; por ello no fue posible cargar el IPA ni crear/seleccionar una versión. Se necesita crear el registro de ChoreJar en App Store Connect o conceder acceso de esa cuenta a la app. No se afirmó que estuviera en revisión.

**Repositorio:** Git fue inicializado localmente para esta entrega. Antes de un push hace falta configurar un remoto; no se encontró ninguno. No se registraron contraseñas, tokens ni material de firma en este archivo.

### 2026-10-16 — control de anuncios, materiales y emuladores (build 10)

El banner de la zona gratuita del padre permanece visible después de una
recompensa y muestra `ChoreJar v1.0.0 (10)` justo encima. Todas las pruebas
mantienen `ADS_LIVE=false`, la aplicación oficial de prueba de Google y las
unidades de prueba de Google; no se activaron IDs reales ni se inició una
sesión de usuario.

La cuenta indicada para preparar ya existía en Firebase. No se cambió, no se
restableció su contraseña y no se inició sesión.

### 2026-10-16 — rediseño infantil y preparación para revisión (1.0.1+11)

Se retiró la función pre-publicación que permitía a un niño solicitar un retiro
de dinero. Ya no existe en el modelo, el repositorio, la vista infantil, la
vista de padre ni las reglas de Firestore. El perfil infantil conserva tareas,
envío a revisión, elección de meta y seguimiento del progreso. Cuando hay saldo
para una meta, la interfaz indica hablar con el padre o madre; no presenta un
botón para pedir, retirar, aprobar, enviar ni gastar dinero.

ChoreJar queda definido para revisión como organizador familiar y registro de
hechos que ocurren fuera de la app. El padre registra una recompensa, mesada,
entrega, movimiento de ahorro o gasto después del evento real. La app no
transfiere, guarda, procesa ni paga fondos, y no ofrece billetera, cuenta de
pago, producto financiero, recompensa en efectivo ni pagos iniciados por niños.
La migración de datos de pruebas normaliza el movimiento interno obsoleto de
retiro como gasto al leerlo; los perfiles nuevos no guardan ese campo.

Los textos de privacidad, fichas de Google Play y App Store, notas de revisión
y guía de materiales se actualizaron en `store_assets/` para la versión 1.0.1
(build 11). El material anterior se conserva bajo `store_assets/archive/` y se
marca expresamente como no apto para envío. Esto alinea el producto y la
declaración de tienda, pero no sustituye el acuerdo legal del titular de la
cuenta ni la decisión final de las tiendas.

Se guardó el paquete de materiales de tienda en `store_assets/`: textos de
ficha y notas en inglés, español latinoamericano y español de España;
gráficos promocionales 1024×500, 1200×628 y 1080×1350; fuentes de los
gráficos; reglas de capturas y un plan de localización. La compilación actual
solo ofrece inglés y español. El plan conserva quince prioridades futuras, sin
declararlas traducidas ni habilitadas.

Validación limpia: `flutter clean`, `flutter pub get`, `flutter analyze` sin
incidencias y `flutter test --concurrency=1` con 45 pruebas aprobadas. La
validación normal de Flutter para simulador falla en su empaquetado de
arquitecturas con Xcode 27; la compilación nativa arm64 de Xcode se completó
correctamente. La misma build de prueba se abrió en iPhone 16e, iPhone 17 Pro
Max y Duo. En Duo, Xcode 27.1 instalado por separado confirmó modo cerrado y
modo abierto horizontal; la captura QA abierta incluye banner de prueba y la
etiqueta de versión. Esas capturas son evidencia interna y no capturas para
las tiendas porque contienen `Test mode` y datos de vista previa local.

### 2026-10-16 — secuencia de capturas de tienda, padre y niño

Se prepararon dos secuencias completas de cinco pantallas de padre y cinco de
niño: inglés (`en-US`) y español latinoamericano (`es-419`). Cubren tareas,
revisión, dinero/ahorro, avance de meta, retiro, ajustes/vinculación y crear
tarea. Están en `store_assets/{google_play,app_store}/1.0.0/screenshots/drafts/`.
Se capturaron desde las pantallas reales de Flutter sobre Duo usando un nuevo
entrypoint aislado, `main_store_screenshot.dart`; solo usa perfil sintético
Alex, anuncios desactivados y jamás inicializa Firebase o una sesión. No
incluyen datos reales, email, contraseña, código de vínculo ni creatividad de
anuncio de prueba. Antes de subir se debe comparar contra el binario final
firmado y los tamaños requeridos por cada tienda.

### 2026-10-16 — verificación autorizada de acceso

Se verificó la credencial de la cuenta indicada por el propietario mediante
Firebase Authentication con la configuración iOS de ChoreJar. Firebase aceptó
el acceso y devolvió una sesión válida. No se guardaron tokens, no se modificó
la cuenta y no se restableció la contraseña.

El intento visual en Device Hub no llegó al servicio: su teclado de emulación
alteró caracteres especiales del correo antes de enviarlo y la app lo rechazó
por validación local. Se ajustó ese caso para que la pantalla de acceso muestre
el mensaje propio de autenticación y nunca el texto genérico sobre campos e
importes. El `TextField` de producción conserva teclado de correo estándar.

### 2026-10-16 — inicio de sesión en simulador Duo

Se confirmó el acceso completo dentro de la versión de depuración de Duo:
correo y contraseña aceptados, sesión restaurada y tablero de familia abierto.
El problema era exclusivo de Device Hub: con `Simulate Hardware Keyboard` el
atajo de automatización introducía `2` en lugar de `@`. Para probar correos en
el simulador, abrir **Device → Keyboard → Toggle Software Keyboard** y tocar
la tecla `@` del teclado de iOS. Esa ruta deja el correo intacto; el acceso
funciona y mantiene únicamente el banner de prueba con la versión visible.

### 2026-10-16 — dispositivo oficial para capturas de tienda

El propietario indicó que todas las capturas de Google Play y App Store deben
proceder de **iPhone 17 Pro Max**. La guía de materiales ahora lo marca como
única fuente de envío para inglés y español. iPhone 16e y Duo se conservan
para comprobar diseño adaptable; sus capturas y los borradores ya existentes
no son material de subida. Se inició el objetivo aislado de capturas en iPhone
17 Pro Max con perfil sintético y anuncios desactivados, para reproducir las
secuencias padre/niño sin Firebase ni datos personales.

Se capturaron y revisaron cuatro candidatas limpias de 1320×2868: padre y
niño en `en-US`, y padre y niño en `es-419`. Están duplicadas para cada tienda
en `store_assets/{app_store,google_play}/1.0.0/screenshots/candidates/` y
siguen siendo candidatas hasta comparar contra el binario firmado. Durante
esta verificación se corrigieron los textos de datos sintéticos para que el
escenario en inglés también use tareas, instrucciones y meta en inglés.
`flutter analyze` y los 45 tests locales terminaron correctamente.

### 2026-10-16 — paquete final de revisión 1.0.1 (build 11)

Se completó la preparación técnica de los binarios de tienda con alcance de
organizador familiar, no financiero. El AAB firmado
`build/app/outputs/bundle/release/app-release.aab` y el IPA
`build/ios/ipa/chorejar.ipa` corresponden a la versión `1.0.1` y build/Android
`11`. Se inspeccionó el IPA: incluye únicamente Runner con
`CFBundleShortVersionString 1.0.1` y `CFBundleVersion 11`, por lo que no hay
extensiones, widgets ni App Clips con versiones divergentes. El AAB fue
verificado como firmado. Los builds de tienda habilitan los banners reales solo
con los defines de producción; desarrollo, pruebas y Duo continúan usando
inventario oficial de prueba.

Validación final realizada: `flutter clean`, `flutter pub get`, `flutter
analyze` sin incidencias, `flutter test --concurrency=1` con 46 pruebas
aprobadas y `node test_support/cloud_smoke.cjs` con 58 comprobaciones. El smoke
test retiró sus usuarios y datos sintéticos. Las reglas de Firestore y hosting
se desplegaron, incluyendo privacidad, términos, soporte y eliminación de
cuenta. Se abrió de nuevo la build de prueba en Duo con Xcode 27.1 instalado
por separado; no se activaron anuncios de producción en esa prueba.

La ficha de Google Play se guardó como borrador en en-US y es-419 con icono,
gráfico destacado y cinco capturas limpias de iPhone 17 Pro Max por idioma. La
pantalla de Play presenta la declaración de recursos creados o editados con IA;
el titular debe responderla con exactitud y completar etiquetas individuales si
la consola las solicita. IARC quedó
reiniciado según el alcance sin cash-out ni recompensas en efectivo: Brasil
Todas las edades, ESRB Everyone, PEGI 3 y USK All ages. La declaración de
audiencia usa los grupos consecutivos 6–8, 9–12, 13–15, 16–17 y 18+, sin 5 y
menores. No se marcó la certificación legal infantil de Play en nombre del
titular.

El impedimento pendiente no es técnico: Google Play requiere que el titular
certifique personalmente el cumplimiento de leyes infantiles para la app, SDKs
y anuncios; Apple exige que el Legal Account Holder acepte sus acuerdos
vigentes y cree o conceda acceso al registro de App Store Connect de
`com.liisgo.chorejar` antes de subir el IPA. No se aceptó ningún acuerdo ni se
afirmó que la app esté publicada o enviada a revisión. El detalle operativo y
las declaraciones de alcance quedan en
`store_assets/review/1.0.1/STORE_SUBMISSION_STATUS.md`.
