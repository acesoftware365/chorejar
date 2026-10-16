/// The public-facing name and familiar allowance term for each supported
/// country.  A family chooses this once during setup, and every linked device
/// receives the same country from Firestore.
class RegionalBrand {
  final String appName;
  final String allowanceTerm;

  const RegionalBrand({required this.appName, required this.allowanceTerm});
}

const _defaultBrand = RegionalBrand(
  appName: 'ChoreJar',
  allowanceTerm: 'Allowance',
);

const countryBrands = <String, RegionalBrand>{
  'US': RegionalBrand(appName: 'ChoreJar', allowanceTerm: 'Allowance'),
  'CA': RegionalBrand(appName: 'ChoreJar', allowanceTerm: 'Allowance'),
  'GB': RegionalBrand(
    appName: 'Pocket Money Jar',
    allowanceTerm: 'Pocket money',
  ),
  'AU': RegionalBrand(
    appName: 'Pocket Money Jar',
    allowanceTerm: 'Pocket money',
  ),
  'IN': RegionalBrand(
    appName: 'Pocket Money Jar',
    allowanceTerm: 'Pocket money',
  ),
  'CH': RegionalBrand(appName: 'ChoreJar', allowanceTerm: 'Pocket money'),
  'DO': RegionalBrand(appName: 'Mi Mesadita', allowanceTerm: 'Mesadita'),
  'ES': RegionalBrand(appName: 'Mi Paga', allowanceTerm: 'Paga'),
  'MX': RegionalBrand(appName: 'Mi Domingo', allowanceTerm: 'Domingo'),
  'GT': RegionalBrand(appName: 'Mi Domingo', allowanceTerm: 'Domingo'),
  'HN': RegionalBrand(appName: 'Mi Domingo', allowanceTerm: 'Domingo'),
  'NI': RegionalBrand(appName: 'Mi Domingo', allowanceTerm: 'Domingo'),
  'CO': RegionalBrand(appName: 'Mi Mesada', allowanceTerm: 'Mesada'),
  'AR': RegionalBrand(appName: 'Mi Mesada', allowanceTerm: 'Mesada'),
  'CL': RegionalBrand(appName: 'Mi Mesada', allowanceTerm: 'Mesada'),
  'UY': RegionalBrand(appName: 'Mi Mesada', allowanceTerm: 'Mesada'),
  'CR': RegionalBrand(appName: 'Mi Mesada', allowanceTerm: 'Mesada'),
  'PA': RegionalBrand(appName: 'Mi Mesada', allowanceTerm: 'Mesada'),
  'BO': RegionalBrand(appName: 'Mi Mesada', allowanceTerm: 'Mesada'),
  'PY': RegionalBrand(appName: 'Mi Mesada', allowanceTerm: 'Mesada'),
  'PE': RegionalBrand(appName: 'Mi Propina', allowanceTerm: 'Propina'),
  'BR': RegionalBrand(appName: 'Minha Mesada', allowanceTerm: 'Mesada'),
  'JP': RegionalBrand(appName: 'こづかいJar', allowanceTerm: '小遣い'),
  'CN': RegionalBrand(appName: '零花钱罐', allowanceTerm: '零花钱'),
  'KR': RegionalBrand(appName: '용돈항아리', allowanceTerm: '용돈'),
  'KW': RegionalBrand(appName: 'مصروفي', allowanceTerm: 'مصروف'),
  'BH': RegionalBrand(appName: 'مصروفي', allowanceTerm: 'مصروف'),
};

RegionalBrand regionalBrandFor(String? country) =>
    countryBrands[country?.toUpperCase()] ?? _defaultBrand;

String appNameFor(String? country, {String fallback = 'ChoreJar'}) {
  if (country == null || country.isEmpty || country == 'otherCountry') {
    return fallback;
  }
  return regionalBrandFor(country).appName;
}
