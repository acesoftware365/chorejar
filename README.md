# ChoreJar / Mi Mesadita
Una app Flutter bilingüe para padres e hijos: tareas, mesadas, entregas manuales y ahorro. No mueve dinero real.

## Ejecutar
Desde `/Users/juanpolanco/StudioProjects/ChoreJar`:

```sh
flutter pub get
flutter run -d 492949A9-5A9A-47B2-A9EE-98ADE015C1C3
```

Referencia: iPhone 17 Pro Max / iOS 26.2. Mínimos configurados: iOS 15 y Android API 24. Se necesita espacio libre suficiente para Xcode, CocoaPods y Gradle. Compilaciones de prueba Android e iOS verificadas el11 de octubre de2026. Android ARM64 instalado/arrancado en emulador API36; iOS instalado/abierto en iPhone JP. Paquetes y guía en /Volumes/Mac2TB/ChoreJarBuilds/2026-10-11/releases. Compilaciones/cachés externas por falta de espacio interno.

## Uso
1. El padre crea su cuenta con correo y contraseña y elige país/moneda. La moneda queda fija para evitar conversiones falsas.
2. Añade hijos con apodo, elige tareas, mesada o ambas, y configura mesada semanal/mensual e inicio.
3. Crea tareas con instrucciones, recompensa y frecuencia. Las tareas recurrentes generan su siguiente ocurrencia al aprobarse, contando desde la aprobación.
4. En Ajustes, genera un código de vinculación de un solo uso (10 minutos). En el dispositivo infantil, elige Niño y escribe ese código. No se necesita correo del niño.
5. El niño envía tareas. El padre aprueba o pide correcciones; únicamente aprobar genera dinero pendiente.
6. El padre registra el dinero que entregó fuera de la app, ahorro, retiros y gastos. Puede corregir movimientos con un reverso y motivo; los originales se conservan.
7. Define una meta de ahorro. La vista infantil incluye Tareas, Mi dinero y Mi meta.
8. Desde Ajustes se cambia idioma, desvinculan dispositivos, archivan perfiles o elimina la cuenta y familia con reautenticación.
9. Para borrar un niño, selecciona su perfil en el modo padres y pulsa el botón rojo «Eliminar niño». La advertencia pide confirmación antes de eliminar ese perfil y su historial de forma irreversible. Archivar sigue disponible para conservar el historial. La acción no aparece en modo niño.

El nombre del icono sigue el idioma del sistema; el selector interno cambia la interfaz y guarda la preferencia.

## Firebase
Proyecto independiente: `chorejar-liisgo-2026`. Firestore Standard en `us-east1`, nivel gratuito, plan Spark; Email/Password y Anonymous habilitados. No se activó facturación, Analytics ni publicidad. Las configuraciones cliente son identificadores públicos, no claves administrativas.

Reglas: `firestore.rules`. Las sesiones de padres y niños tienen permisos distintos. El niño solo puede leer su perfil activo y cambiar una tarea pendiente/corregida a revisión. No puede aprobar ni editar recompensas, perfiles ni historial. Un código aleatorio vincula una sesión anónima; no es un PIN que desbloquea privilegios de padres. Revocar incrementa la versión de acceso y elimina vínculos/códigos existentes.

Las operaciones monetarias usan transacciones online sobre el perfil; no hay escrituras financieras pendientes offline. Se desactiva la caché persistente de Firestore. Si se pierde el acceso, se retiran los datos de la pantalla.

```sh
firebase deploy --only firestore:rules,firestore:indexes --project chorejar-liisgo-2026
```

## Pruebas
```sh
flutter analyze
flutter test --concurrency=1
node test_support/cloud_smoke.cjs
```

La prueba cloud usa el proyecto configurado y crea cuentas/documentos sintéticos temporales, verifica permisos y elimina sus propios datos al finalizar. Nunca imprime contraseñas ni tokens. Espera la propagación de reglas tras un despliegue antes de ejecutarla. No modifica familias existentes.

Para emuladores, arrancar los servicios definidos en firebase.json y usar `--dart-define=FIREBASE_EMULATOR=true`; en un emulador Android, añadir `--dart-define=EMULATOR_HOST=10.0.2.2`. Se usa el mismo ID de proyecto solo como namespace local: los servicios Auth y Firestore se redirigen a localhost.

## Reglas del dinero
Los importes se guardan en unidades menores enteras según moneda (0, 2 o 3 decimales). Pendiente = recompensas aprobadas + mesadas devengadas − entregas, neto de reversos. Recibido = disponible + ahorro + gastos netos. Ahorrar transfiere disponible a ahorro, nunca suma ingresos. Cada entrega se asigna a recompensas concretas y admite parciales. Los identificadores de operación evitan duplicados en reintentos. Para revertir una recompensa ya entregada deben revertirse sus entregas; no se permiten saldos negativos.

Las mesadas se devengan al abrir/actualizar el área padre, no mediante un proceso de pago automático. Cada plan/fecha tiene un identificador único; los meses cortos respetan el día elegido en meses siguientes. Se procesan como máximo 120 periodos por actualización, sin descartar periodos posteriores.

## Vista previa local
“Explorar sin cuenta” es un entorno de prueba claramente identificado. Guarda en el directorio privado de la app mediante escritura temporal y reemplazo atómico. No tiene autenticación, no sincroniza ni se mezcla automáticamente con familias reales. No lo utilices para datos sensibles. El cambio de roles existe solo en la vista previa y en la previsualización autorizada del padre.

## Estructura
- lib/models/family.dart: tareas, mesadas, libro de movimientos, reversos y saldos.
- lib/services/repository.dart: persistencia local y transacciones/suscripciones Firebase.
- lib/services/money.dart: monedas y conversiones exactas de texto a unidades menores.
- lib/screens/: acceso y pantallas funcionales.
- lib/widgets/: componentes y formularios reutilizables.
- assets/l10n/: traducciones JSON independientes.
- lib/assets/library.dart y assets/library/: catálogo compartido e imágenes WebP (201 KB en total).
- design/source-images/: originales de ilustración, excluidos del paquete de la app.
- design/ASSET_LIBRARY.txt: tamaños, presupuesto y regeneración de recursos.
- store/: textos de tienda ES/EN y notas previas a publicación.
- test/ y test_support/: pruebas.
- PROJECT_LOG.md: historial completo.

## Límites de la primera versión
Un padre propietario por familia, una moneda familiar y una meta activa por hijo. Se mantienen tareas/movimientos por perfil en un documento con límite preventivo de 750 KB; al alcanzarlo se avisa sin borrar historial. La aprobación del padre es la autoridad del registro: las reglas protegen frente al niño y otras familias, no frente a un padre que actúe fuera de la aplicación sobre sus propios datos. No incluye transferencias bancarias, conversión de divisas, notificaciones push ni automatización de servidor.

La app no está publicada en tiendas. La preparación de la primera entrega usa
`1.0.0+10`, enlaces públicos de privacidad y soporte en el hosting de ChoreJar,
y los IDs reales de AdMob únicamente para builds de tienda. Android exige una
clave de subida del propietario en `android/key.properties`; nunca permite la
firma de depuración en release. iOS usa firma automática del equipo
`3M9854JZ4Y` y requiere una identidad Apple Distribution y un perfil App Store
válidos antes de archivar. Faltan las credenciales de distribución y la sesión
de App Store Connect para poder enviar los binarios.

### Dos padres en una familia
En una cuenta conectada, Ajustes → Acceso para dos padres permite al creador invitar una segunda cuenta con código privado de 10 minutos y un solo uso. El segundo adulto activa «Tengo una invitación de otro padre» al iniciar sesión o registrarse con su propio correo. Debe usar una cuenta que todavía no pertenezca a otra familia; no se fusionan familias existentes. Ambos administran los mismos niños, tareas y saldos. Solo el creador puede invitar y eliminar toda la familia. El segundo padre puede abandonar el acceso o eliminar únicamente su propia cuenta; los datos familiares se conservan. La demo local solo explica esta función.

La pertenencia se guarda en un único documento parentMembers por familia, con parentLinks para reanudar sesión y parentInvites para canje atómico. Las reglas limitan la familia a dos adultos y comprueban pertenencia en cada solicitud. Revocar borra atómicamente pertenencia y enlace; los códigos emitidos por el creador se limpian después. No se envían correos automáticamente.

### Invitación sencilla
Ajustes → Añadir otro padre → Compartir invitación abre el selector del teléfono (por ejemplo, WhatsApp o Mensajes). La invitación usa `chorejar://join-parent?code=...`; requiere ChoreJar instalada. No es un enlace web universal ni instala la app. El receptor ve «Te invitaron a la familia» con la invitación preparada, entra con su propio correo o crea su cuenta. Si el mensajero no hace clicable el enlace, puede copiar el mensaje completo y usar «Recibí una invitación» → «Pegar invitación». Se conserva el código como alternativa. No se envía nada automáticamente ni se lee el portapapeles sin tocar Pegar.
Configuración iOS/Android de esquema y app_links; share_plus abre selector nativo con posición para iPad. Las reglas y la caducidad no cambian. La apertura desde otras apps y el selector de compartir necesitan verificación en builds nativas instaladas antes de publicar en tiendas.

### Inicio guiado
WelcomeFlow ofrece elección padre/niño y accesos directos para cuentas existentes e invitaciones. Las familias nuevas pasan por cuenta (con país/moneda), nombre/avatar infantil, tarea/recompensa opcional y confirmación. Los perfiles se guardan al terminar el paso de tarea; los borradores no se conservan al cerrar la app. Una cuenta conectada sin perfiles retoma el alta infantil. Las invitaciones no crean otra familia. Demo aislada: `lib/main_welcome_preview.dart`, ruta web `/welcome/`, sin credenciales ni sincronización.

### Metas del niño
El niño vinculado puede elegir imagen, nombre y precio de su propia meta desde Mi meta. El precio es un objetivo de ahorro, no crea dinero ni pagos. El cambio se comparte con los padres. Catálogo: iPhone, bicicleta, videojuegos, audífonos, peluche, patineta, tableta y otro regalo. Las tres imágenes nuevas suman unos62KB; biblioteca completa263300bytes. Saldos e historial continúan bajo control parental.

El catálogo ahora incluye18 opciones: se añadieron tenis, mochila, balón, cámara, guitarra, robot, bloques, patinete, reloj y kit de arte. La galería se desplaza dentro del formulario. Toda la biblioteca de imágenes optimizadas ocupa477698bytes (aprox.478KB), incluyendo frasco, alcancía y marca; originales fuera del paquete. Test de catálogo exige18 opciones y presupuesto500KiB.
