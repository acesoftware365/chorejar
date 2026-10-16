/// Shared lightweight asset catalog. Stable IDs are stored in family profiles.
/// Original artwork lives in design/source-images and is not bundled.
class LibraryAsset {
  final String id, path;
  final int width, height;
  const LibraryAsset(this.id, this.path, this.width, this.height);
}

const goalImageIds = [
  'iphone',
  'bicycle',
  'console',
  'headphones',
  'teddy',
  'skateboard',
  'tablet',
  'sneakers',
  'backpack',
  'soccer',
  'camera',
  'guitar',
  'robot',
  'blocks',
  'scooter',
  'watch',
  'artkit',
  'gift',
];

abstract final class AssetLibrary {
  static const jar = LibraryAsset(
    'money-jar',
    'assets/library/money-jar.webp',
    748,
    768,
  );
  static const pig = LibraryAsset(
    'piggy-bank',
    'assets/library/piggy-bank.webp',
    384,
    384,
  );
  static const brand = LibraryAsset(
    'chorejar-icon-v2',
    'assets/library/chorejar-icon-v2.webp',
    256,
    256,
  );
  static const goals = {
    'sneakers': LibraryAsset(
      'sneakers',
      'assets/library/sneakers.webp',
      384,
      384,
    ),
    'backpack': LibraryAsset(
      'backpack',
      'assets/library/backpack.webp',
      384,
      384,
    ),
    'soccer': LibraryAsset('soccer', 'assets/library/soccer.webp', 384, 384),
    'camera': LibraryAsset('camera', 'assets/library/camera.webp', 384, 384),
    'guitar': LibraryAsset('guitar', 'assets/library/guitar.webp', 384, 384),
    'robot': LibraryAsset('robot', 'assets/library/robot.webp', 384, 384),
    'blocks': LibraryAsset('blocks', 'assets/library/blocks.webp', 384, 384),
    'scooter': LibraryAsset('scooter', 'assets/library/scooter.webp', 384, 384),
    'watch': LibraryAsset('watch', 'assets/library/watch.webp', 384, 384),
    'artkit': LibraryAsset('artkit', 'assets/library/artkit.webp', 384, 384),

    'teddy': LibraryAsset('teddy', 'assets/library/teddy.webp', 384, 384),
    'skateboard': LibraryAsset(
      'skateboard',
      'assets/library/skateboard.webp',
      384,
      384,
    ),
    'tablet': LibraryAsset('tablet', 'assets/library/tablet.webp', 384, 384),
    'iphone': LibraryAsset('iphone', 'assets/library/iphone.webp', 384, 384),
    'bicycle': LibraryAsset('bicycle', 'assets/library/bicycle.webp', 384, 384),
    'console': LibraryAsset('console', 'assets/library/console.webp', 384, 384),
    'headphones': LibraryAsset(
      'headphones',
      'assets/library/headphones.webp',
      384,
      384,
    ),
  };
  static Iterable<LibraryAsset> get all => [jar, pig, brand, ...goals.values];
}
