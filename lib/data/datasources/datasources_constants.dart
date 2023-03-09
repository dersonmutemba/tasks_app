Map<String, dynamic> datasourcesConstants = {
  'noteTable': 'note',
  'noteColumns': ['id', 'title', 'content', 'createdAt', 'lastEdited'],
  'noteTableQuery': '''
      CREATE TABLE ${datasourcesConstants['noteTable']}(
        ${datasourcesConstants['noteTable'][0]} TEXT PRIMARY KEY,
        ${datasourcesConstants['noteTable'][1]} TEXT NOT NULL,
        ${datasourcesConstants['noteTable'][2]} TEXT NOT NULL,
        ${datasourcesConstants['noteTable'][3]} DATETIME NOT NULL,
        ${datasourcesConstants['noteTable'][4]} DATETIME NOT NULL
      );'''
};
