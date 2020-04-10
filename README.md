# power-rake-deploy
Deploy an app w/ config using Ansible.

- Depends on infrastructure created by `power-rake-provision`
- Example deployable application `rack-app-example`


### Prerequisites 
- AWS API credentials
- HashiCorp Vault


### 1. SSH into instances

> defaults to `env=development` and `conf=config.yml`

```
make ssh
make ssh env=production
make ssh env=production conf=project/config.yml
```


### 2. Upload SSL certs to instances

> defaults to `env=development` and `conf=config.yml`

```
make upload_cert
make upload_cert env=production
make upload_cert env=production conf=project/config.yml
```

### 3. Deploy app

```
roadmap:
- rake task
- aws integration
```

---

### 4. Display info

```
roadmap:
- rake task
 * show running instances
```

---

### 5. Edit application config

```
roadmap:
- rake task
```
