---
title: Basic authentication
weight: 1
---

By default, whenever you create a fresh cluster, an admin user is created,
with the username `admin` and a randomly generated password.
This password is printed out following the successful creation of the cluster.

{{< callout type="info" >}}
The password is printed following the successful creation of the cluster.
It is not stored anywhere on the cluster, and it is not possible to retrieve it
later. Thus, if the password is not saved in the install output logs, you must recreate the cluster to gain access.
{{< /callout >}}

An admin user can create users, change user passwords, and delete users from
the MKE 4k system.

## Create users

1. Log in to the MKE 4k Dashboard as an administrator.

2. Navigate to **Access Control** --> **Users** to access the **user** page.

3. Click the **Create User** button at the far right to access the **User Creation** page.

4. Enter the pertinent information into the following fields:

   * **username**
   * **password**
   * **confirm password**

   {{< callout type="info" >}}
   You can enter the name of the user into the **name** field, however this is
   optional and the input is not in use in MKE 4k.
   {{< /callout >}}

5. Optional. If the user you are creating is to be an admin, tick the
   **admin** checkbox.

## Change a password

1. Log in to the MKE 4k Dashboard as an administrator.

2. Navigate to **Access Control** --> **Users** to access the **user** page.

3. Click the username for the user whose password you want to change. The
   page for that particular user will display.

4. Click **Update password** at the top right of the user page to access the
   **update password** page.

5. Enter the new password in to the **new password** field and confirm it in
   the **confirm new password** field.

6. Click **Update** in the bottom right corner of the page.

## Delete users

1. Log in to the MKE 4k Dashboard as an administrator.

2. Navigate to **Access Control** --> **Users** to access the **user** page.

3. Tick the checkbox to the left of the username for the user you want to
   delete. You can tick multiple boxes to delete multiple users at the same time.

4. Click the **actions** dropdown at the far top right of the page and select
   **remove**. A **Delete** confirmation dialog will display.

5. Click **Delete** to remove the user from the MKE 4k system.

Alternately, you can delete a user from their dedicated user page:

1.  Click the username for the user you want to delete to access their dedicated
user page.

2. Click **Delete** at the far top right of the page. A **Delete** confirmation
   dialog will display.

3. Click **Delete** to remove the user from the MKE 4k system.
