enum FavoriteAction { ADD, REMOVE }

typedef OnChangeFavoriteCallback = void Function(FavoriteAction action);
