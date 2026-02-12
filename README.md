Walkthrough - Fixing the ACM Deadlock
I have fixed the issue where Terraform hangs and CloudFront fails with a 400 error.

Why it failed
The Hang: Terraform waits for ACM to validate your domain. But ACM cannot validate until you update your nameservers at your registrar.
The 400 Error: When you interrupted Terraform, it left CloudFront trying to use a certificate that wasn't "Issued" yet. AWS doesn't allow attaching unvalidated certificates.
The Solution: A Staged Rollout
I have added an ssl_ready toggle in 
main.tf
. This allows us to "break the deadlock".

Step 1: Get Nameservers (Do this now)
I've already configured your code for this:

use_custom_domain = true
ssl_ready = false
Run terraform apply. It will finish instantly!
Get Nameservers: Check the Terraform output for nameservers.
Update Registrar: Go to GoDaddy/Namecheap and update your domain's nameservers.
Step 2: Go Live (Do this after 20 mins)
Wait about 20 minutes for DNS to propagate.
Check the AWS ACM Console; the status should be "Issued".
In 
main.tf
, set:
hcl
ssl_ready = true
Run terraform apply. This will finish the project and enable HTTPS!
This two-step process is the standard way to handle new domains in Terraform.
