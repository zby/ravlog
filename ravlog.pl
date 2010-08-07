{
  name => 'RavLog',
  using_frontend_proxy => 0,
  site => {
    template => 'default',
    name => 'Writers Unite!',
    description => 'a writers blog',
  },
  'Model::DB' => {
    schema_class => 'RavLog::Schema',
    connect_info => [
        'dbi:SQLite:dbname=./ravlog.db',
    ],
  }
}


