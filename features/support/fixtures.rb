Fixtures.reset_cache
fixtures_folder = File.join(RAILS_ROOT, 'spec', 'fixtures')
fixtures = ['users', 'roles', 'privileges', 'privileges_roles']
Fixtures.create_fixtures(fixtures_folder, fixtures)
