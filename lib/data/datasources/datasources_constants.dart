Map<String, dynamic> _datasourcesConstants = {
  'noteTable': 'note',
  'noteColumns': ['id', 'title', 'content', 'createdAt', 'lastEdited'],
  'taskTable': 'task',
  'taskColumns': ['id', 'name', 'description', 'icon', 'createdAt', 'lastEdited', 'startedAt', 'dueDate', 'status'],
};

Map<String, dynamic> datasourcesConstants = {
  'noteTable': 'note',
  'noteColumns': ['id', 'title', 'content', 'createdAt', 'lastEdited'],
  'taskTable': 'task',
  'taskColumns': ['id', 'name', 'description', 'icon', 'createdAt', 'lastEdited', 'startedAt', 'dueDate', 'status'],
  'tablesQuery': [
    '''CREATE TABLE if not exists ${_datasourcesConstants['noteTable']}(
        ${_datasourcesConstants['noteColumns'][0]} TEXT PRIMARY KEY,
        ${_datasourcesConstants['noteColumns'][1]} TEXT NOT NULL,
        ${_datasourcesConstants['noteColumns'][2]} TEXT NOT NULL,
        ${_datasourcesConstants['noteColumns'][3]} DATETIME NOT NULL,
        ${_datasourcesConstants['noteColumns'][4]} DATETIME NOT NULL
      );''',
    '''CREATE TABLE if not exists ${_datasourcesConstants['taskTable']}(
        ${_datasourcesConstants['taskColumns'][0]} TEXT PRIMARY KEY,
        ${_datasourcesConstants['taskColumns'][1]} TEXT NOT NULL,
        ${_datasourcesConstants['taskColumns'][2]} TEXT,
        ${_datasourcesConstants['taskColumns'][3]} TEXT,
        ${_datasourcesConstants['taskColumns'][4]} DATETIME NOT NULL,
        ${_datasourcesConstants['taskColumns'][5]} DATETIME,
        ${_datasourcesConstants['taskColumns'][6]} DATETIME,
        ${_datasourcesConstants['taskColumns'][7]} DATETIME,
        ${_datasourcesConstants['taskColumns'][8]} TEXT NOT NULL
      );
  '''
  ],
};
