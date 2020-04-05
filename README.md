# power-rake-deploy
Deploy an app w/ config using Ansible.

- Depends on infrastructure created by `power-rake-provision`
- Example deployable application `rack-app-example`


### Prerequisites 
- AWS API credentials
- Ansible


### Power Rake Configuration

```
export RAKE_ENV=production                  # optional - default = development
export RAKE_PROJECT=example                 # required - used to identify the current project
```

Want to have separate config files for different projects?

```
export RAKE_CONFIG=other-project.yml        # optional - path to yaml file
```

### 1. SSH into instances

```
bundle exec rake ssh
```


### 2. Deploy app

```
roadmap:
- rake task
- aws integration
```

---

### 3. Display info

```
roadmap:
- rake task
 * show running instances
```

---

### 4. Edit application config

```
roadmap:
- rake task
```
