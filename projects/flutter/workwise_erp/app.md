Using clean architecture , create the folders accordingly 
core, features,assets(images)
in core create;
constants
errors (Either.dart, exceptions, failure.dart)
localization
provider
widgets
utils
network
themes (app_colors.dart ,singleton, primary color is blue, secondary is yellow, then other colors like white, black)
Create one feature for Auth 
Entities User 
id                          | bigint unsigned | NO   | PRI | NULL    | auto_increment |
| name                        | varchar(191)    | YES  |     | NULL    |                |
| email                       | varchar(191)    | NO   | UNI | NULL    |                |
| email_verified_at           | timestamp       | YES  |     | NULL    |                |
| password                    | varchar(191)    | YES  |     | NULL    |                |
| email_verification_token    | varchar(191)    | YES  | UNI | NULL    |                |
| plan                        | int             | YES  |     | NULL    |                |
| plan_expire_date            | datetime        | YES  |     | NULL    |                |
| requested_plan              | int             | NO   |     | 0       |                |
| client_id                   | int             | YES  |     | NULL    |                |
| employee_id                 | varchar(191)    | YES  |     | NULL    |                |
| is_admin                    | int unsigned    | NO   |     | 0       |                |
| vender_id                   | int             | YES  |     | NULL    |                |
| currency_id                 | bigint unsigned | YES  | MUL | NULL    |                |
| type                        | varchar(100)    | YES  |     | NULL    |                |
| storage_limit               | double(8,2)     | NO   |     | 0.00    |                |
| avatar                      | varchar(100)    | YES  |     | NULL    |                |
| lang                        | varchar(100)    | YES  |     | NULL    |                |
| mode                        | varchar(10)     | NO   |     | light   |                |
| created_by                  | int             | NO   | MUL | 0       |                |
| default_pipeline            | int             | YES  |     | NULL    |                |
| delete_status               | int             | NO   |     | 1       |                |
| is_active                   | int             | NO   |     | 1       |                |
| mobile_registration_enabled | tinyint(1)      | NO   |     | 0       |                |
| remember_token              | varchar(100)    | YES  |     | NULL    |                |
| last_login_at               | datetime        | YES  |     | NULL    |                |
| created_at                  | timestamp       | YES  |     | NULL    |                |
| updated_at                  | timestamp       | YES  |     | NULL    |                |
| messenger_color             | varchar(191)    | NO   |     | #2180f3 |                |
| dark_mode                   | tinyint(1)      | NO   |     | 0       |                |
| active_status               | tinyint(1)      | NO   |     | 0       |                |
| is_email_verified           | tinyint(1)      | NO   |     | 0       |                |
| phone                       | varchar(191)    | NO   |     | NULL    |                |
| otp                         | varchar(191)    | YES  |     | NULL    |                |
| otp_expired                 | timestamp       | YES  |     | NULL    |                |
| industry                    | varchar(191)    | NO   |     | NULL    |                |
| max_seats                   | int             | YES  |     | NULL    |                |
| requested_storage_plan      | int             | NO   |     | 0       |                |
| storagePlan                 | int             | NO   |     | NULL    |                |
| storage_plan_expire_date    | date            | YES  |     | NULL    |                |
| api_token                   | varchar(191)    | YES  |     | NULL    |                |
| distributor_id              | bigint unsigned | YES  | MUL | NULL    |                |
| super_dealer                | varchar(191)    | YES  |     | NULL    |                |
+-----------------------------+-----------------+------+-----+---------+----------------+


For now let's start small  and if you have any question , clarification, any extra details let me know




 