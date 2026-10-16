# Nombres regionales de ChoreJar

La familia escoge el país al crear su cuenta. La aplicación guarda ese país y
usa el nombre regional en el teléfono de padre, el dispositivo infantil y las
vistas previas. No cambia los datos ni la moneda después de creada la familia.

| País | Nombre visible en la app | Término local para la asignación |
| --- | --- | --- |
| Estados Unidos, Canadá | ChoreJar | Allowance |
| Reino Unido, Australia, India | Pocket Money Jar | Pocket money |
| República Dominicana | Mi Mesadita | Mesadita |
| España | Mi Paga | Paga |
| México, Guatemala, Honduras, Nicaragua | Mi Domingo | Domingo |
| Colombia, Argentina, Chile, Uruguay, Costa Rica, Panamá, Bolivia, Paraguay | Mi Mesada | Mesada |
| Perú | Mi Propina | Propina |
| Brasil | Minha Mesada | Mesada |
| Japón | こづかいJar | 小遣い (kozukai) |
| China | 零花钱罐 | 零花钱 |
| Corea del Sur | 용돈항아리 | 용돈 (yongdon) |
| Kuwait, Baréin | مصروفي | مصروف |
| Suiza | ChoreJar | Pocket money |

## Publicación en App Store y Google Play

Un solo paquete ajusta el nombre **dentro de la aplicación** usando el país de
la familia.

- **Google Play:** una misma app Android puede usar *Custom Store Listings*
  dirigidos por país y cambiar el nombre, ícono, descripciones y artes de cada
  ficha. Así se puede publicar `Mi Mesadita` en República Dominicana y `Mi
  Domingo` en México sin crear dos APK ni dos productos.
- **App Store:** se puede localizar el nombre visible de la ficha y el que se
  instala, pero Apple elige la localización a partir del idioma y el locale de
  la tienda o dispositivo. Sirve muy bien para Español (España), Español
  (México), Portugués (Brasil), Japonés, Coreano y Árabe. No permite garantizar
  títulos distintos para varios países que usan exactamente el mismo locale
  español.

Para dos mercados de iOS que requieren nombres diferentes con el mismo locale,
la alternativa es crear fichas y paquetes separados. Antes de hacerlo, validar
marca, texto nativo y soporte, porque cada ficha requiere revisión y su propio
ciclo de publicación.

## Fuentes lingüísticas usadas

- Cambridge define `paga` como el dinero regular que los padres dan a un niño:
  https://dictionary.cambridge.org/dictionary/spanish-english/paga
- Cambridge traduce *pocket money* como `mesada` en portugués brasileño:
  https://dictionary.cambridge.org/dictionary/portuguese-english/mesada
- Cambridge registra `小遣い` para la asignación o dinero de bolsillo japonés:
  https://dictionary.cambridge.org/dictionary/english-japanese/pocket-money
- Cambridge registra `용돈` para la asignación o dinero de bolsillo coreano:
  https://dictionary.cambridge.org/dictionary/english-korean/pocket-money
- Google Play permite fichas personalizadas por país que cambian el nombre y
  recursos sin cambiar el paquete: https://support.google.com/googleplay/android-developer/answer/9867158
- Apple permite localizar el nombre de la app por idioma o locale:
  https://developer.apple.com/help/app-store-connect/manage-app-information/localize-app-information

Las variantes de uso cotidiano de los mercados hispanohablantes se centralizan
en `lib/services/regional_brand.dart` para que puedan ajustarse sin tocar el
flujo ni los datos de las familias.
