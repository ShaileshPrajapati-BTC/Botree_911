roles = Role.create([{ name: 'client' }, { name: 'admin' }, { name: 'project manager' }, { name: 'team leader' }, { name: 'team member' }])
user = User.create( email: 'admin@ex.com', password: '123456' )
user.add_role :admin