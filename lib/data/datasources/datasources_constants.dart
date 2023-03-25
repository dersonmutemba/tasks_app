Map<String, dynamic> _datasourcesConstants = {
  'noteTable': 'note',
  'noteColumns': ['id', 'title', 'content', 'createdAt', 'lastEdited'],
};

Map<String, dynamic> datasourcesConstants = {
  'noteTable': 'note',
  'noteColumns': ['id', 'title', 'content', 'createdAt', 'lastEdited'],
  'noteTableQuery': '''
      CREATE TABLE if not exists ${_datasourcesConstants['noteTable']}(
        ${_datasourcesConstants['noteColumns'][0]} TEXT PRIMARY KEY,
        ${_datasourcesConstants['noteColumns'][1]} TEXT NOT NULL,
        ${_datasourcesConstants['noteColumns'][2]} TEXT NOT NULL,
        ${_datasourcesConstants['noteColumns'][3]} DATETIME NOT NULL,
        ${_datasourcesConstants['noteColumns'][4]} DATETIME NOT NULL
      );'''
};
