# Contributing to Terraform EKS Blueprint

## Code Standards

### Terraform Best Practices

1. **Formatting**
   ```bash
   terraform fmt -recursive
   ```

2. **Validation**
   ```bash
   terraform validate
   cd environments/dev && terraform init -backend=false && terraform validate
   cd ../prod && terraform init -backend=false && terraform validate
   ```

3. **Security**
   - Never commit `terraform.tfvars` files
   - Use `sensitive = true` for outputs containing secrets
   - Use `TF_VAR_*` environment variables for sensitive inputs
   - Review IAM policies for least privilege

### File Organization

- One resource per block (no multiple resources in one block)
- Alphabetize variables and outputs
- Use consistent indentation (2 spaces)
- Add descriptions to all variables and outputs
- Keep lines under 100 characters when possible

### Naming Conventions

- **Resources**: `resource_type_purpose` (e.g., `aws_security_group_eks_nodes`)
- **Modules**: `module_purpose` (e.g., `vpc`, `eks`, `karpenter`)
- **Variables**: `lowercase_with_underscores`
- **Outputs**: `descriptive_name`
- **Locals**: `purpose_name`
- **Data sources**: `data_source_purpose`

### Documentation

Every module should include:
- README.md with purpose and usage
- Description on all variables
- Description on all outputs
- Examples in comments
- Variable validation rules

## Development Workflow

### 1. Create Feature Branch

```bash
git checkout -b feature/add-monitoring
# or
git checkout -b fix/security-group-issue
# or
git checkout -b docs/update-readme
```

### 2. Make Changes

```bash
# Add your changes
git add .
```

### 3. Format and Validate

```bash
# Format all Terraform files
terraform fmt -recursive

# Validate each environment
cd environments/dev && terraform init -backend=false && terraform validate && cd ../..
cd environments/prod && terraform init -backend=false && terraform validate && cd ../..

# Check for security issues (optional, requires tfsec)
tfsec .
```

### 4. Test Changes

```bash
cd environments/dev
terraform init
terraform plan -out=tfplan
# Review the plan carefully
terraform apply tfplan
```

### 5. Commit Changes

```bash
git commit -m "feat: add monitoring module

- Add CloudWatch log group for EKS cluster
- Add container insights configuration
- Update outputs with log group ARN

Fixes #123"
```

### 6. Push and Create Pull Request

```bash
git push origin feature/add-monitoring
```

## Pull Request Checklist

- [ ] Branch is up to date with `main`
- [ ] Code formatted with `terraform fmt`
- [ ] All variables have descriptions
- [ ] All outputs have descriptions
- [ ] Variables validated appropriately
- [ ] README.md updated if needed
- [ ] Changes tested in dev environment
- [ ] No sensitive data in commit
- [ ] Commit messages are clear and descriptive
- [ ] No unnecessary files committed

## Review Process

### For Reviewers

1. **Code Quality**
   - Follows naming conventions
   - Properly formatted
   - No unnecessary complexity

2. **Functionality**
   - Changes work as described
   - Tests pass
   - No breaking changes

3. **Security**
   - No security vulnerabilities introduced
   - Follows least privilege principle
   - No secrets in code

4. **Documentation**
   - Changes are documented
   - README updated
   - Examples provided if needed

## Testing Guidelines

### Manual Testing

```bash
# Test in development first
cd environments/dev
terraform plan -out=tfplan
terraform apply tfplan

# Verify resources
kubectl get nodes
kubectl get pods -A

# Clean up
terraform destroy
```

### Validation Checklist

- [ ] `terraform init` succeeds
- [ ] `terraform plan` completes without errors
- [ ] `terraform apply` creates resources successfully
- [ ] New resources are accessible
- [ ] Tags are applied correctly
- [ ] Security groups have correct rules
- [ ] Networking is configured properly
- [ ] Add-ons are deployed

## Handling Issues

### Before Opening an Issue

1. Check existing issues for similar problems
2. Try the troubleshooting guide in README.md
3. Verify your environment meets prerequisites
4. Collect debug information:
   ```bash
   terraform version
   aws --version
   kubectl version --client
   ```

### Issue Template

```markdown
## Description
[Brief description of the issue]

## Steps to Reproduce
1. ...
2. ...

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- Terraform version: 
- AWS region: 
- OS: 

## Error Messages
[Paste full error messages if any]

## Configuration
[Paste relevant configuration (remove sensitive data)]
```

## Release Process

1. Update CHANGELOG.md with version changes
2. Create release branch: `release/v1.2.0`
3. Update version in files
4. Create pull request for review
5. After approval, merge to `main`
6. Tag release: `git tag v1.2.0`
7. Push tag: `git push origin v1.2.0`

## Support Channels

- **Issues**: Use GitHub Issues for bugs and feature requests
- **Discussions**: Use GitHub Discussions for general questions
- **Documentation**: Check README.md and module READMEs first
- **Security**: Report security issues to [security contact]

## Code of Conduct

- Be respectful and constructive
- Provide helpful feedback
- Give credit where due
- Ask clarifying questions
- Assume good intentions

---

**Thank you for contributing!** 🎉
