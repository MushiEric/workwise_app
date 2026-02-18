{
    "status": 200,
    "message": "Login successful",
    "token": "7|zdeo3tlMGrBU8fYlErVa1CUPv72vkP98KfvTa0NX87bc6b49",
    "token_type": "Bearer",
    "settings": {
        "shot_time": ""
    },
    "users": {
        "id": 3,
        "name": "Eric Prosper",
        "email": "ericprosper603@gmail.com",
        "email_verified_at": "2025-11-05T06:56:55.000000Z",
        "email_verification_token": null,
        "plan": 2,
        "plan_expire_date": null,
        "requested_plan": 0,
        "client_id": null,
        "employee_id": null,
        "is_admin": 0,
        "vender_id": null,
        "currency_id": null,
        "type": "company",
        "storage_limit": 0.54,
        "avatar": null,
        "lang": "en",
        "mode": "light",
        "created_by": 2,
        "default_pipeline": 1,
        "delete_status": 1,
        "is_active": 1,
        "mobile_registration_enabled": 0,
        "last_login_at": "2026-02-12 21:35:05",
        "created_at": "2025-11-05T06:56:55.000000Z",
        "updated_at": "2026-02-12T18:35:05.000000Z",
        "messenger_color": "#2180f3",
        "dark_mode": 0,
        "active_status": 1,
        "is_email_verified": true,
        "phone": "255613334247",
        "otp": null,
        "otp_expired": null,
        "industry": "",
        "max_seats": null,
        "requested_storage_plan": 0,
        "storagePlan": 0,
        "storage_plan_expire_date": null,
        "api_token": null,
        "distributor_id": null,
        "super_dealer": null,
        "profile": "http://localhost:8000/storage/avatar.png",
        "roles": [
            {
                "id": 4,
                "name": "company",
                "guard_name": "web",
                "created_by": 1,
                "created_at": "2025-11-05T06:48:35.000000Z",
                "updated_at": "2025-11-05T06:48:35.000000Z",
                "pivot": {
                    "model_id": 3,
                    "role_id": 4,
                    "model_type": "App\\Models\\User"
                },
                "permissions": [
                    {
                        "id": 1,
                        "name": "show pos dashboard",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1
                        }
                    },
                    {
                        "id": 2,
                        "name": "show crm dashboard",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 2
                        }
                    },
                    {
                        "id": 3,
                        "name": "show hrm dashboard",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 3
                        }
                    },
                    {
                        "id": 4,
                        "name": "copy invoice",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 4
                        }
                    },
                    {
                        "id": 5,
                        "name": "show project dashboard",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 5
                        }
                    },
                    {
                        "id": 6,
                        "name": "show matter dashboard",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 6
                        }
                    },
                    {
                        "id": 7,
                        "name": "show account dashboard",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 7
                        }
                    },
                    {
                        "id": 8,
                        "name": "manage user",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 8
                        }
                    },
                    {
                        "id": 9,
                        "name": "create user",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 9
                        }
                    },
                    {
                        "id": 10,
                        "name": "edit user",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 10
                        }
                    },
                    {
                        "id": 11,
                        "name": "delete user",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 11
                        }
                    },
                    {
                        "id": 14,
                        "name": "manage role",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 14
                        }
                    },
                    {
                        "id": 15,
                        "name": "create role",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 15
                        }
                    },
                    {
                        "id": 16,
                        "name": "edit role",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 16
                        }
                    },
                    {
                        "id": 17,
                        "name": "delete role",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 17
                        }
                    },
                    {
                        "id": 18,
                        "name": "manage permission",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 18
                        }
                    },
                    {
                        "id": 19,
                        "name": "create permission",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 19
                        }
                    },
                    {
                        "id": 20,
                        "name": "edit permission",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 20
                        }
                    },
                    {
                        "id": 21,
                        "name": "delete permission",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 21
                        }
                    },
                    {
                        "id": 23,
                        "name": "manage print settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 23
                        }
                    },
                    {
                        "id": 24,
                        "name": "manage business settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 24
                        }
                    },
                    {
                        "id": 26,
                        "name": "manage expense",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 26
                        }
                    },
                    {
                        "id": 27,
                        "name": "create expense",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 27
                        }
                    },
                    {
                        "id": 28,
                        "name": "edit expense",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 28
                        }
                    },
                    {
                        "id": 29,
                        "name": "delete expense",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 29
                        }
                    },
                    {
                        "id": 30,
                        "name": "manage invoice",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 30
                        }
                    },
                    {
                        "id": 31,
                        "name": "create invoice",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 31
                        }
                    },
                    {
                        "id": 32,
                        "name": "edit invoice",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 32
                        }
                    },
                    {
                        "id": 33,
                        "name": "delete invoice",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 33
                        }
                    },
                    {
                        "id": 34,
                        "name": "show invoice",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 34
                        }
                    },
                    {
                        "id": 35,
                        "name": "create payment invoice",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 35
                        }
                    },
                    {
                        "id": 36,
                        "name": "delete payment invoice",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 36
                        }
                    },
                    {
                        "id": 37,
                        "name": "send invoice",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 37
                        }
                    },
                    {
                        "id": 38,
                        "name": "delete invoice product",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 38
                        }
                    },
                    {
                        "id": 39,
                        "name": "convert invoice",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 39
                        }
                    },
                    {
                        "id": 40,
                        "name": "manage constant unit",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 40
                        }
                    },
                    {
                        "id": 41,
                        "name": "create constant unit",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 41
                        }
                    },
                    {
                        "id": 42,
                        "name": "edit constant unit",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 42
                        }
                    },
                    {
                        "id": 43,
                        "name": "delete constant unit",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 43
                        }
                    },
                    {
                        "id": 44,
                        "name": "manage constant tax",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 44
                        }
                    },
                    {
                        "id": 45,
                        "name": "create constant tax",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 45
                        }
                    },
                    {
                        "id": 46,
                        "name": "edit constant tax",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 46
                        }
                    },
                    {
                        "id": 47,
                        "name": "delete constant tax",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 47
                        }
                    },
                    {
                        "id": 48,
                        "name": "manage constant category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 48
                        }
                    },
                    {
                        "id": 49,
                        "name": "create constant category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 49
                        }
                    },
                    {
                        "id": 50,
                        "name": "edit constant category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 50
                        }
                    },
                    {
                        "id": 51,
                        "name": "delete constant category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 51
                        }
                    },
                    {
                        "id": 52,
                        "name": "manage items",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 52
                        }
                    },
                    {
                        "id": 53,
                        "name": "create items",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 53
                        }
                    },
                    {
                        "id": 54,
                        "name": "edit items",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 54
                        }
                    },
                    {
                        "id": 55,
                        "name": "delete items",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 55
                        }
                    },
                    {
                        "id": 56,
                        "name": "manage customer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 56
                        }
                    },
                    {
                        "id": 57,
                        "name": "create customer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 57
                        }
                    },
                    {
                        "id": 58,
                        "name": "edit customer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 58
                        }
                    },
                    {
                        "id": 59,
                        "name": "delete customer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 59
                        }
                    },
                    {
                        "id": 60,
                        "name": "show customer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 60
                        }
                    },
                    {
                        "id": 61,
                        "name": "manage bank account",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 61
                        }
                    },
                    {
                        "id": 62,
                        "name": "create bank account",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 62
                        }
                    },
                    {
                        "id": 63,
                        "name": "edit bank account",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 63
                        }
                    },
                    {
                        "id": 64,
                        "name": "delete bank account",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 64
                        }
                    },
                    {
                        "id": 65,
                        "name": "manage bank",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 65
                        }
                    },
                    {
                        "id": 66,
                        "name": "create bank",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 66
                        }
                    },
                    {
                        "id": 67,
                        "name": "edit bank",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 67
                        }
                    },
                    {
                        "id": 68,
                        "name": "delete bank",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 68
                        }
                    },
                    {
                        "id": 69,
                        "name": "manage bank transfer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 69
                        }
                    },
                    {
                        "id": 70,
                        "name": "create bank transfer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 70
                        }
                    },
                    {
                        "id": 71,
                        "name": "edit bank transfer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 71
                        }
                    },
                    {
                        "id": 72,
                        "name": "delete bank transfer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 72
                        }
                    },
                    {
                        "id": 73,
                        "name": "manage transaction",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 73
                        }
                    },
                    {
                        "id": 74,
                        "name": "manage revenue",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 74
                        }
                    },
                    {
                        "id": 75,
                        "name": "create revenue",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 75
                        }
                    },
                    {
                        "id": 76,
                        "name": "edit revenue",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 76
                        }
                    },
                    {
                        "id": 77,
                        "name": "delete revenue",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 77
                        }
                    },
                    {
                        "id": 78,
                        "name": "manage bill",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 78
                        }
                    },
                    {
                        "id": 79,
                        "name": "create bill",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 79
                        }
                    },
                    {
                        "id": 80,
                        "name": "edit bill",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 80
                        }
                    },
                    {
                        "id": 81,
                        "name": "delete bill",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 81
                        }
                    },
                    {
                        "id": 82,
                        "name": "show bill",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 82
                        }
                    },
                    {
                        "id": 83,
                        "name": "manage payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 83
                        }
                    },
                    {
                        "id": 84,
                        "name": "create payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 84
                        }
                    },
                    {
                        "id": 85,
                        "name": "edit payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 85
                        }
                    },
                    {
                        "id": 86,
                        "name": "delete payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 86
                        }
                    },
                    {
                        "id": 87,
                        "name": "delete bill product",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 87
                        }
                    },
                    {
                        "id": 88,
                        "name": "send bill",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 88
                        }
                    },
                    {
                        "id": 89,
                        "name": "create payment bill",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 89
                        }
                    },
                    {
                        "id": 90,
                        "name": "delete payment bill",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 90
                        }
                    },
                    {
                        "id": 91,
                        "name": "manage order",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 91
                        }
                    },
                    {
                        "id": 92,
                        "name": "manage order status change",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 92
                        }
                    },
                    {
                        "id": 93,
                        "name": "income report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 93
                        }
                    },
                    {
                        "id": 94,
                        "name": "expense report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 94
                        }
                    },
                    {
                        "id": 95,
                        "name": "income vs expense report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 95
                        }
                    },
                    {
                        "id": 96,
                        "name": "invoice report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 96
                        }
                    },
                    {
                        "id": 97,
                        "name": "bill report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 97
                        }
                    },
                    {
                        "id": 98,
                        "name": "stock report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 98
                        }
                    },
                    {
                        "id": 99,
                        "name": "tax report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 99
                        }
                    },
                    {
                        "id": 100,
                        "name": "loss & profit report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 100
                        }
                    },
                    {
                        "id": 104,
                        "name": "manage credit note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 104
                        }
                    },
                    {
                        "id": 105,
                        "name": "create credit note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 105
                        }
                    },
                    {
                        "id": 106,
                        "name": "edit credit note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 106
                        }
                    },
                    {
                        "id": 107,
                        "name": "delete credit note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 107
                        }
                    },
                    {
                        "id": 108,
                        "name": "manage debit note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 108
                        }
                    },
                    {
                        "id": 109,
                        "name": "create debit note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 109
                        }
                    },
                    {
                        "id": 110,
                        "name": "edit debit note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 110
                        }
                    },
                    {
                        "id": 111,
                        "name": "delete debit note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 111
                        }
                    },
                    {
                        "id": 112,
                        "name": "duplicate invoice",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 112
                        }
                    },
                    {
                        "id": 113,
                        "name": "duplicate bill",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 113
                        }
                    },
                    {
                        "id": 115,
                        "name": "manage goal",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 115
                        }
                    },
                    {
                        "id": 116,
                        "name": "create goal",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 116
                        }
                    },
                    {
                        "id": 117,
                        "name": "edit goal",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 117
                        }
                    },
                    {
                        "id": 118,
                        "name": "delete goal",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 118
                        }
                    },
                    {
                        "id": 119,
                        "name": "manage assets",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 119
                        }
                    },
                    {
                        "id": 120,
                        "name": "create assets",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 120
                        }
                    },
                    {
                        "id": 121,
                        "name": "edit assets",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 121
                        }
                    },
                    {
                        "id": 122,
                        "name": "delete assets",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 122
                        }
                    },
                    {
                        "id": 123,
                        "name": "statement report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 123
                        }
                    },
                    {
                        "id": 124,
                        "name": "manage constant custom field",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 124
                        }
                    },
                    {
                        "id": 125,
                        "name": "create constant custom field",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 125
                        }
                    },
                    {
                        "id": 126,
                        "name": "edit constant custom field",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 126
                        }
                    },
                    {
                        "id": 127,
                        "name": "delete constant custom field",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 127
                        }
                    },
                    {
                        "id": 128,
                        "name": "manage chart of account",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 128
                        }
                    },
                    {
                        "id": 129,
                        "name": "create chart of account",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 129
                        }
                    },
                    {
                        "id": 130,
                        "name": "edit chart of account",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 130
                        }
                    },
                    {
                        "id": 131,
                        "name": "delete chart of account",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 131
                        }
                    },
                    {
                        "id": 132,
                        "name": "manage chart of account type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 132
                        }
                    },
                    {
                        "id": 133,
                        "name": "create chart of account type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 133
                        }
                    },
                    {
                        "id": 134,
                        "name": "edit chart of account type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 134
                        }
                    },
                    {
                        "id": 135,
                        "name": "delete chart of account type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 135
                        }
                    },
                    {
                        "id": 136,
                        "name": "manage chart of account sub type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 136
                        }
                    },
                    {
                        "id": 137,
                        "name": "create chart of account sub type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 137
                        }
                    },
                    {
                        "id": 138,
                        "name": "edit chart of account sub type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 138
                        }
                    },
                    {
                        "id": 139,
                        "name": "delete chart of account sub type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 139
                        }
                    },
                    {
                        "id": 140,
                        "name": "manage journal entry",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 140
                        }
                    },
                    {
                        "id": 141,
                        "name": "create journal entry",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 141
                        }
                    },
                    {
                        "id": 142,
                        "name": "edit journal entry",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 142
                        }
                    },
                    {
                        "id": 143,
                        "name": "delete journal entry",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 143
                        }
                    },
                    {
                        "id": 144,
                        "name": "show journal entry",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 144
                        }
                    },
                    {
                        "id": 145,
                        "name": "balance sheet report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 145
                        }
                    },
                    {
                        "id": 146,
                        "name": "ledger report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 146
                        }
                    },
                    {
                        "id": 147,
                        "name": "trial balance report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 147
                        }
                    },
                    {
                        "id": 148,
                        "name": "manage client",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 148
                        }
                    },
                    {
                        "id": 149,
                        "name": "create client",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 149
                        }
                    },
                    {
                        "id": 150,
                        "name": "edit client",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 150
                        }
                    },
                    {
                        "id": 151,
                        "name": "delete client",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 151
                        }
                    },
                    {
                        "id": 152,
                        "name": "manage lead",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 152
                        }
                    },
                    {
                        "id": 153,
                        "name": "create lead",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 153
                        }
                    },
                    {
                        "id": 154,
                        "name": "view lead",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 154
                        }
                    },
                    {
                        "id": 155,
                        "name": "edit lead",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 155
                        }
                    },
                    {
                        "id": 156,
                        "name": "delete lead",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 156
                        }
                    },
                    {
                        "id": 157,
                        "name": "move lead",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 157
                        }
                    },
                    {
                        "id": 158,
                        "name": "create lead call",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 158
                        }
                    },
                    {
                        "id": 159,
                        "name": "edit lead call",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 159
                        }
                    },
                    {
                        "id": 160,
                        "name": "delete lead call",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 160
                        }
                    },
                    {
                        "id": 161,
                        "name": "create lead email",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 161
                        }
                    },
                    {
                        "id": 162,
                        "name": "manage pipeline",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 162
                        }
                    },
                    {
                        "id": 163,
                        "name": "create pipeline",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 163
                        }
                    },
                    {
                        "id": 164,
                        "name": "edit pipeline",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 164
                        }
                    },
                    {
                        "id": 165,
                        "name": "delete pipeline",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 165
                        }
                    },
                    {
                        "id": 166,
                        "name": "manage lead stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 166
                        }
                    },
                    {
                        "id": 167,
                        "name": "create lead stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 167
                        }
                    },
                    {
                        "id": 168,
                        "name": "edit lead stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 168
                        }
                    },
                    {
                        "id": 169,
                        "name": "delete lead stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 169
                        }
                    },
                    {
                        "id": 170,
                        "name": "convert lead to deal",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 170
                        }
                    },
                    {
                        "id": 171,
                        "name": "manage source",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 171
                        }
                    },
                    {
                        "id": 172,
                        "name": "create source",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 172
                        }
                    },
                    {
                        "id": 173,
                        "name": "edit source",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 173
                        }
                    },
                    {
                        "id": 174,
                        "name": "delete source",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 174
                        }
                    },
                    {
                        "id": 175,
                        "name": "manage label",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 175
                        }
                    },
                    {
                        "id": 176,
                        "name": "create label",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 176
                        }
                    },
                    {
                        "id": 177,
                        "name": "edit label",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 177
                        }
                    },
                    {
                        "id": 178,
                        "name": "delete label",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 178
                        }
                    },
                    {
                        "id": 179,
                        "name": "manage deal",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 179
                        }
                    },
                    {
                        "id": 180,
                        "name": "create deal",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 180
                        }
                    },
                    {
                        "id": 181,
                        "name": "view task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 181
                        }
                    },
                    {
                        "id": 182,
                        "name": "create task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 182
                        }
                    },
                    {
                        "id": 183,
                        "name": "edit task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 183
                        }
                    },
                    {
                        "id": 184,
                        "name": "delete task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 184
                        }
                    },
                    {
                        "id": 185,
                        "name": "edit deal",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 185
                        }
                    },
                    {
                        "id": 186,
                        "name": "view deal",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 186
                        }
                    },
                    {
                        "id": 187,
                        "name": "delete deal",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 187
                        }
                    },
                    {
                        "id": 188,
                        "name": "move deal",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 188
                        }
                    },
                    {
                        "id": 189,
                        "name": "create deal call",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 189
                        }
                    },
                    {
                        "id": 190,
                        "name": "edit deal call",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 190
                        }
                    },
                    {
                        "id": 191,
                        "name": "delete deal call",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 191
                        }
                    },
                    {
                        "id": 192,
                        "name": "create deal email",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 192
                        }
                    },
                    {
                        "id": 193,
                        "name": "manage stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 193
                        }
                    },
                    {
                        "id": 194,
                        "name": "create stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 194
                        }
                    },
                    {
                        "id": 195,
                        "name": "edit stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 195
                        }
                    },
                    {
                        "id": 196,
                        "name": "delete stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 196
                        }
                    },
                    {
                        "id": 197,
                        "name": "manage employee",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 197
                        }
                    },
                    {
                        "id": 198,
                        "name": "create employee",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 198
                        }
                    },
                    {
                        "id": 199,
                        "name": "view employee",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 199
                        }
                    },
                    {
                        "id": 200,
                        "name": "edit employee",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 200
                        }
                    },
                    {
                        "id": 201,
                        "name": "delete employee",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 201
                        }
                    },
                    {
                        "id": 202,
                        "name": "manage employee profile",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 202
                        }
                    },
                    {
                        "id": 203,
                        "name": "show employee profile",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 203
                        }
                    },
                    {
                        "id": 204,
                        "name": "manage department",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 204
                        }
                    },
                    {
                        "id": 205,
                        "name": "create department",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 205
                        }
                    },
                    {
                        "id": 206,
                        "name": "view department",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 206
                        }
                    },
                    {
                        "id": 207,
                        "name": "edit department",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 207
                        }
                    },
                    {
                        "id": 208,
                        "name": "delete department",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 208
                        }
                    },
                    {
                        "id": 209,
                        "name": "manage designation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 209
                        }
                    },
                    {
                        "id": 210,
                        "name": "create designation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 210
                        }
                    },
                    {
                        "id": 211,
                        "name": "view designation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 211
                        }
                    },
                    {
                        "id": 212,
                        "name": "edit designation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 212
                        }
                    },
                    {
                        "id": 213,
                        "name": "delete designation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 213
                        }
                    },
                    {
                        "id": 214,
                        "name": "manage branch",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 214
                        }
                    },
                    {
                        "id": 215,
                        "name": "create branch",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 215
                        }
                    },
                    {
                        "id": 216,
                        "name": "edit branch",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 216
                        }
                    },
                    {
                        "id": 217,
                        "name": "delete branch",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 217
                        }
                    },
                    {
                        "id": 218,
                        "name": "manage document type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 218
                        }
                    },
                    {
                        "id": 219,
                        "name": "create document type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 219
                        }
                    },
                    {
                        "id": 220,
                        "name": "edit document type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 220
                        }
                    },
                    {
                        "id": 221,
                        "name": "delete document type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 221
                        }
                    },
                    {
                        "id": 222,
                        "name": "manage document",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 222
                        }
                    },
                    {
                        "id": 223,
                        "name": "create document",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 223
                        }
                    },
                    {
                        "id": 224,
                        "name": "edit document",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 224
                        }
                    },
                    {
                        "id": 225,
                        "name": "delete document",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 225
                        }
                    },
                    {
                        "id": 226,
                        "name": "manage payslip type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 226
                        }
                    },
                    {
                        "id": 227,
                        "name": "create payslip type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 227
                        }
                    },
                    {
                        "id": 228,
                        "name": "edit payslip type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 228
                        }
                    },
                    {
                        "id": 229,
                        "name": "delete payslip type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 229
                        }
                    },
                    {
                        "id": 230,
                        "name": "create allowance",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 230
                        }
                    },
                    {
                        "id": 231,
                        "name": "edit allowance",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 231
                        }
                    },
                    {
                        "id": 232,
                        "name": "delete allowance",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 232
                        }
                    },
                    {
                        "id": 233,
                        "name": "create commission",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 233
                        }
                    },
                    {
                        "id": 234,
                        "name": "edit commission",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 234
                        }
                    },
                    {
                        "id": 235,
                        "name": "delete commission",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 235
                        }
                    },
                    {
                        "id": 236,
                        "name": "manage allowance option",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 236
                        }
                    },
                    {
                        "id": 237,
                        "name": "create allowance option",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 237
                        }
                    },
                    {
                        "id": 238,
                        "name": "edit allowance option",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 238
                        }
                    },
                    {
                        "id": 239,
                        "name": "delete allowance option",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 239
                        }
                    },
                    {
                        "id": 240,
                        "name": "manage loan option",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 240
                        }
                    },
                    {
                        "id": 241,
                        "name": "create loan option",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 241
                        }
                    },
                    {
                        "id": 242,
                        "name": "edit loan option",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 242
                        }
                    },
                    {
                        "id": 243,
                        "name": "delete loan option",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 243
                        }
                    },
                    {
                        "id": 244,
                        "name": "manage deduction option",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 244
                        }
                    },
                    {
                        "id": 245,
                        "name": "create deduction option",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 245
                        }
                    },
                    {
                        "id": 246,
                        "name": "edit deduction option",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 246
                        }
                    },
                    {
                        "id": 247,
                        "name": "delete deduction option",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 247
                        }
                    },
                    {
                        "id": 248,
                        "name": "create loan",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 248
                        }
                    },
                    {
                        "id": 249,
                        "name": "edit loan",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 249
                        }
                    },
                    {
                        "id": 250,
                        "name": "delete loan",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 250
                        }
                    },
                    {
                        "id": 251,
                        "name": "create other deduction",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 251
                        }
                    },
                    {
                        "id": 252,
                        "name": "edit other deduction",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 252
                        }
                    },
                    {
                        "id": 253,
                        "name": "delete other deduction",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 253
                        }
                    },
                    {
                        "id": 254,
                        "name": "create other payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 254
                        }
                    },
                    {
                        "id": 255,
                        "name": "edit other payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 255
                        }
                    },
                    {
                        "id": 256,
                        "name": "delete other payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 256
                        }
                    },
                    {
                        "id": 257,
                        "name": "create overtime",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 257
                        }
                    },
                    {
                        "id": 258,
                        "name": "edit overtime",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 258
                        }
                    },
                    {
                        "id": 259,
                        "name": "delete overtime",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 259
                        }
                    },
                    {
                        "id": 260,
                        "name": "manage set salary",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 260
                        }
                    },
                    {
                        "id": 261,
                        "name": "edit set salary",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 261
                        }
                    },
                    {
                        "id": 262,
                        "name": "manage pay slip",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 262
                        }
                    },
                    {
                        "id": 263,
                        "name": "create set salary",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 263
                        }
                    },
                    {
                        "id": 264,
                        "name": "create pay slip",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 264
                        }
                    },
                    {
                        "id": 265,
                        "name": "manage company policy",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 265
                        }
                    },
                    {
                        "id": 266,
                        "name": "create company policy",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 266
                        }
                    },
                    {
                        "id": 267,
                        "name": "edit company policy",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 267
                        }
                    },
                    {
                        "id": 268,
                        "name": "manage appraisal",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 268
                        }
                    },
                    {
                        "id": 269,
                        "name": "create appraisal",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 269
                        }
                    },
                    {
                        "id": 270,
                        "name": "edit appraisal",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 270
                        }
                    },
                    {
                        "id": 271,
                        "name": "show appraisal",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 271
                        }
                    },
                    {
                        "id": 272,
                        "name": "delete appraisal",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 272
                        }
                    },
                    {
                        "id": 273,
                        "name": "manage goal tracking",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 273
                        }
                    },
                    {
                        "id": 274,
                        "name": "create goal tracking",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 274
                        }
                    },
                    {
                        "id": 275,
                        "name": "edit goal tracking",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 275
                        }
                    },
                    {
                        "id": 276,
                        "name": "delete goal tracking",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 276
                        }
                    },
                    {
                        "id": 277,
                        "name": "manage goal type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 277
                        }
                    },
                    {
                        "id": 278,
                        "name": "create goal type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 278
                        }
                    },
                    {
                        "id": 279,
                        "name": "edit goal type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 279
                        }
                    },
                    {
                        "id": 280,
                        "name": "delete goal type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 280
                        }
                    },
                    {
                        "id": 281,
                        "name": "manage indicator",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 281
                        }
                    },
                    {
                        "id": 282,
                        "name": "create indicator",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 282
                        }
                    },
                    {
                        "id": 283,
                        "name": "edit indicator",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 283
                        }
                    },
                    {
                        "id": 284,
                        "name": "show indicator",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 284
                        }
                    },
                    {
                        "id": 285,
                        "name": "delete indicator",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 285
                        }
                    },
                    {
                        "id": 286,
                        "name": "manage training",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 286
                        }
                    },
                    {
                        "id": 287,
                        "name": "create training",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 287
                        }
                    },
                    {
                        "id": 288,
                        "name": "edit training",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 288
                        }
                    },
                    {
                        "id": 289,
                        "name": "delete training",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 289
                        }
                    },
                    {
                        "id": 290,
                        "name": "show training",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 290
                        }
                    },
                    {
                        "id": 291,
                        "name": "manage trainer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 291
                        }
                    },
                    {
                        "id": 292,
                        "name": "create trainer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 292
                        }
                    },
                    {
                        "id": 293,
                        "name": "edit trainer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 293
                        }
                    },
                    {
                        "id": 294,
                        "name": "delete trainer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 294
                        }
                    },
                    {
                        "id": 295,
                        "name": "manage training type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 295
                        }
                    },
                    {
                        "id": 296,
                        "name": "create training type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 296
                        }
                    },
                    {
                        "id": 297,
                        "name": "edit training type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 297
                        }
                    },
                    {
                        "id": 298,
                        "name": "delete training type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 298
                        }
                    },
                    {
                        "id": 299,
                        "name": "manage award",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 299
                        }
                    },
                    {
                        "id": 300,
                        "name": "create award",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 300
                        }
                    },
                    {
                        "id": 301,
                        "name": "edit award",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 301
                        }
                    },
                    {
                        "id": 302,
                        "name": "delete award",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 302
                        }
                    },
                    {
                        "id": 303,
                        "name": "manage award type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 303
                        }
                    },
                    {
                        "id": 304,
                        "name": "create award type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 304
                        }
                    },
                    {
                        "id": 305,
                        "name": "edit award type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 305
                        }
                    },
                    {
                        "id": 306,
                        "name": "delete award type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 306
                        }
                    },
                    {
                        "id": 307,
                        "name": "manage resignation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 307
                        }
                    },
                    {
                        "id": 308,
                        "name": "create resignation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 308
                        }
                    },
                    {
                        "id": 309,
                        "name": "edit resignation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 309
                        }
                    },
                    {
                        "id": 310,
                        "name": "delete resignation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 310
                        }
                    },
                    {
                        "id": 311,
                        "name": "manage travel",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 311
                        }
                    },
                    {
                        "id": 312,
                        "name": "create travel",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 312
                        }
                    },
                    {
                        "id": 313,
                        "name": "edit travel",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 313
                        }
                    },
                    {
                        "id": 314,
                        "name": "delete travel",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 314
                        }
                    },
                    {
                        "id": 315,
                        "name": "manage promotion",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 315
                        }
                    },
                    {
                        "id": 316,
                        "name": "create promotion",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 316
                        }
                    },
                    {
                        "id": 317,
                        "name": "edit promotion",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 317
                        }
                    },
                    {
                        "id": 318,
                        "name": "delete promotion",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 318
                        }
                    },
                    {
                        "id": 319,
                        "name": "manage complaint",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 319
                        }
                    },
                    {
                        "id": 320,
                        "name": "create complaint",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 320
                        }
                    },
                    {
                        "id": 321,
                        "name": "edit complaint",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 321
                        }
                    },
                    {
                        "id": 322,
                        "name": "delete complaint",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 322
                        }
                    },
                    {
                        "id": 323,
                        "name": "manage warning",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 323
                        }
                    },
                    {
                        "id": 324,
                        "name": "create warning",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 324
                        }
                    },
                    {
                        "id": 325,
                        "name": "edit warning",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 325
                        }
                    },
                    {
                        "id": 326,
                        "name": "delete warning",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 326
                        }
                    },
                    {
                        "id": 327,
                        "name": "manage termination",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 327
                        }
                    },
                    {
                        "id": 328,
                        "name": "create termination",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 328
                        }
                    },
                    {
                        "id": 329,
                        "name": "edit termination",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 329
                        }
                    },
                    {
                        "id": 330,
                        "name": "delete termination",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 330
                        }
                    },
                    {
                        "id": 331,
                        "name": "manage termination type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 331
                        }
                    },
                    {
                        "id": 332,
                        "name": "create termination type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 332
                        }
                    },
                    {
                        "id": 333,
                        "name": "edit termination type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 333
                        }
                    },
                    {
                        "id": 334,
                        "name": "delete termination type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 334
                        }
                    },
                    {
                        "id": 335,
                        "name": "manage job application",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 335
                        }
                    },
                    {
                        "id": 336,
                        "name": "create job application",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 336
                        }
                    },
                    {
                        "id": 337,
                        "name": "show job application",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 337
                        }
                    },
                    {
                        "id": 338,
                        "name": "delete job application",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 338
                        }
                    },
                    {
                        "id": 339,
                        "name": "move job application",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 339
                        }
                    },
                    {
                        "id": 340,
                        "name": "add job application skill",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 340
                        }
                    },
                    {
                        "id": 341,
                        "name": "add job application note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 341
                        }
                    },
                    {
                        "id": 342,
                        "name": "delete job application note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 342
                        }
                    },
                    {
                        "id": 343,
                        "name": "manage job onBoard",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 343
                        }
                    },
                    {
                        "id": 344,
                        "name": "manage job category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 344
                        }
                    },
                    {
                        "id": 345,
                        "name": "create job category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 345
                        }
                    },
                    {
                        "id": 346,
                        "name": "edit job category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 346
                        }
                    },
                    {
                        "id": 347,
                        "name": "delete job category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 347
                        }
                    },
                    {
                        "id": 348,
                        "name": "manage job",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 348
                        }
                    },
                    {
                        "id": 349,
                        "name": "create job",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 349
                        }
                    },
                    {
                        "id": 350,
                        "name": "edit job",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 350
                        }
                    },
                    {
                        "id": 351,
                        "name": "show job",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 351
                        }
                    },
                    {
                        "id": 352,
                        "name": "delete job",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 352
                        }
                    },
                    {
                        "id": 353,
                        "name": "manage job stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 353
                        }
                    },
                    {
                        "id": 354,
                        "name": "create job stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 354
                        }
                    },
                    {
                        "id": 355,
                        "name": "edit job stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 355
                        }
                    },
                    {
                        "id": 356,
                        "name": "delete job stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 356
                        }
                    },
                    {
                        "id": 357,
                        "name": "Manage Competencies",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 357
                        }
                    },
                    {
                        "id": 358,
                        "name": "Create Competencies",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 358
                        }
                    },
                    {
                        "id": 359,
                        "name": "Edit Competencies",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 359
                        }
                    },
                    {
                        "id": 360,
                        "name": "Delete Competencies",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 360
                        }
                    },
                    {
                        "id": 361,
                        "name": "manage custom question",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 361
                        }
                    },
                    {
                        "id": 362,
                        "name": "create custom question",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 362
                        }
                    },
                    {
                        "id": 363,
                        "name": "edit custom question",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 363
                        }
                    },
                    {
                        "id": 364,
                        "name": "delete custom question",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 364
                        }
                    },
                    {
                        "id": 365,
                        "name": "create interview schedule",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 365
                        }
                    },
                    {
                        "id": 366,
                        "name": "edit interview schedule",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 366
                        }
                    },
                    {
                        "id": 367,
                        "name": "delete interview schedule",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 367
                        }
                    },
                    {
                        "id": 368,
                        "name": "show interview schedule",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 368
                        }
                    },
                    {
                        "id": 369,
                        "name": "create estimation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 369
                        }
                    },
                    {
                        "id": 370,
                        "name": "view estimation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 370
                        }
                    },
                    {
                        "id": 371,
                        "name": "edit estimation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 371
                        }
                    },
                    {
                        "id": 372,
                        "name": "delete estimation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 372
                        }
                    },
                    {
                        "id": 373,
                        "name": "edit holiday",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 373
                        }
                    },
                    {
                        "id": 374,
                        "name": "create holiday",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 374
                        }
                    },
                    {
                        "id": 375,
                        "name": "delete holiday",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 375
                        }
                    },
                    {
                        "id": 376,
                        "name": "manage holiday",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 376
                        }
                    },
                    {
                        "id": 377,
                        "name": "show career",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 377
                        }
                    },
                    {
                        "id": 378,
                        "name": "manage meeting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 378
                        }
                    },
                    {
                        "id": 379,
                        "name": "create meeting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 379
                        }
                    },
                    {
                        "id": 380,
                        "name": "edit meeting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 380
                        }
                    },
                    {
                        "id": 381,
                        "name": "delete meeting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 381
                        }
                    },
                    {
                        "id": 382,
                        "name": "manage event",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 382
                        }
                    },
                    {
                        "id": 383,
                        "name": "create event",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 383
                        }
                    },
                    {
                        "id": 384,
                        "name": "edit event",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 384
                        }
                    },
                    {
                        "id": 385,
                        "name": "delete event",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 385
                        }
                    },
                    {
                        "id": 386,
                        "name": "manage transfer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 386
                        }
                    },
                    {
                        "id": 387,
                        "name": "create transfer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 387
                        }
                    },
                    {
                        "id": 388,
                        "name": "edit transfer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 388
                        }
                    },
                    {
                        "id": 389,
                        "name": "delete transfer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 389
                        }
                    },
                    {
                        "id": 390,
                        "name": "manage announcement",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 390
                        }
                    },
                    {
                        "id": 391,
                        "name": "create announcement",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 391
                        }
                    },
                    {
                        "id": 392,
                        "name": "edit announcement",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 392
                        }
                    },
                    {
                        "id": 393,
                        "name": "delete announcement",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 393
                        }
                    },
                    {
                        "id": 394,
                        "name": "manage leave",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 394
                        }
                    },
                    {
                        "id": 395,
                        "name": "create leave",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 395
                        }
                    },
                    {
                        "id": 396,
                        "name": "edit leave",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 396
                        }
                    },
                    {
                        "id": 397,
                        "name": "delete leave",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 397
                        }
                    },
                    {
                        "id": 398,
                        "name": "manage leave type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 398
                        }
                    },
                    {
                        "id": 399,
                        "name": "create leave type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 399
                        }
                    },
                    {
                        "id": 400,
                        "name": "edit leave type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 400
                        }
                    },
                    {
                        "id": 401,
                        "name": "delete leave type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 401
                        }
                    },
                    {
                        "id": 402,
                        "name": "manage attendance",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 402
                        }
                    },
                    {
                        "id": 403,
                        "name": "create attendance",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 403
                        }
                    },
                    {
                        "id": 404,
                        "name": "edit attendance",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 404
                        }
                    },
                    {
                        "id": 405,
                        "name": "delete attendance",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 405
                        }
                    },
                    {
                        "id": 406,
                        "name": "manage report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 406
                        }
                    },
                    {
                        "id": 407,
                        "name": "manage project",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 407
                        }
                    },
                    {
                        "id": 408,
                        "name": "create project",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 408
                        }
                    },
                    {
                        "id": 409,
                        "name": "view project",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 409
                        }
                    },
                    {
                        "id": 410,
                        "name": "edit project",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 410
                        }
                    },
                    {
                        "id": 411,
                        "name": "delete project",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 411
                        }
                    },
                    {
                        "id": 412,
                        "name": "share project",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 412
                        }
                    },
                    {
                        "id": 413,
                        "name": "create milestone",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 413
                        }
                    },
                    {
                        "id": 414,
                        "name": "edit milestone",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 414
                        }
                    },
                    {
                        "id": 415,
                        "name": "delete milestone",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 415
                        }
                    },
                    {
                        "id": 416,
                        "name": "view milestone",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 416
                        }
                    },
                    {
                        "id": 417,
                        "name": "view grant chart",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 417
                        }
                    },
                    {
                        "id": 418,
                        "name": "manage project stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 418
                        }
                    },
                    {
                        "id": 419,
                        "name": "create project stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 419
                        }
                    },
                    {
                        "id": 420,
                        "name": "edit project stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 420
                        }
                    },
                    {
                        "id": 421,
                        "name": "delete project stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 421
                        }
                    },
                    {
                        "id": 422,
                        "name": "view timesheet",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 422
                        }
                    },
                    {
                        "id": 423,
                        "name": "view expense",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 423
                        }
                    },
                    {
                        "id": 424,
                        "name": "manage project task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 424
                        }
                    },
                    {
                        "id": 425,
                        "name": "create project task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 425
                        }
                    },
                    {
                        "id": 426,
                        "name": "edit project task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 426
                        }
                    },
                    {
                        "id": 427,
                        "name": "view project task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 427
                        }
                    },
                    {
                        "id": 428,
                        "name": "delete project task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 428
                        }
                    },
                    {
                        "id": 429,
                        "name": "view activity",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 429
                        }
                    },
                    {
                        "id": 430,
                        "name": "view CRM activity",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 430
                        }
                    },
                    {
                        "id": 431,
                        "name": "manage project task stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 431
                        }
                    },
                    {
                        "id": 432,
                        "name": "edit project task stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 432
                        }
                    },
                    {
                        "id": 433,
                        "name": "create project task stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 433
                        }
                    },
                    {
                        "id": 434,
                        "name": "delete project task stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 434
                        }
                    },
                    {
                        "id": 435,
                        "name": "manage timesheet",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 435
                        }
                    },
                    {
                        "id": 436,
                        "name": "manage matter timesheet",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 436
                        }
                    },
                    {
                        "id": 437,
                        "name": "create timesheet",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 437
                        }
                    },
                    {
                        "id": 438,
                        "name": "create matter timesheet",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 438
                        }
                    },
                    {
                        "id": 439,
                        "name": "edit timesheet",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 439
                        }
                    },
                    {
                        "id": 440,
                        "name": "edit matter timesheet",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 440
                        }
                    },
                    {
                        "id": 441,
                        "name": "delete timesheet",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 441
                        }
                    },
                    {
                        "id": 442,
                        "name": "delete matter timesheet",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 442
                        }
                    },
                    {
                        "id": 443,
                        "name": "manage bug report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 443
                        }
                    },
                    {
                        "id": 444,
                        "name": "create bug report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 444
                        }
                    },
                    {
                        "id": 445,
                        "name": "edit bug report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 445
                        }
                    },
                    {
                        "id": 446,
                        "name": "delete bug report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 446
                        }
                    },
                    {
                        "id": 447,
                        "name": "move bug report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 447
                        }
                    },
                    {
                        "id": 448,
                        "name": "manage bug status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 448
                        }
                    },
                    {
                        "id": 449,
                        "name": "create bug status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 449
                        }
                    },
                    {
                        "id": 450,
                        "name": "edit bug status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 450
                        }
                    },
                    {
                        "id": 451,
                        "name": "delete bug status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 451
                        }
                    },
                    {
                        "id": 454,
                        "name": "manage system settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 454
                        }
                    },
                    {
                        "id": 455,
                        "name": "manage plan",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 455
                        }
                    },
                    {
                        "id": 462,
                        "name": "manage company plan",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 462
                        }
                    },
                    {
                        "id": 463,
                        "name": "buy plan",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 463
                        }
                    },
                    {
                        "id": 464,
                        "name": "manage form builder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 464
                        }
                    },
                    {
                        "id": 465,
                        "name": "create form builder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 465
                        }
                    },
                    {
                        "id": 466,
                        "name": "edit form builder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 466
                        }
                    },
                    {
                        "id": 467,
                        "name": "delete form builder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 467
                        }
                    },
                    {
                        "id": 468,
                        "name": "manage performance type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 468
                        }
                    },
                    {
                        "id": 469,
                        "name": "create performance type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 469
                        }
                    },
                    {
                        "id": 470,
                        "name": "edit performance type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 470
                        }
                    },
                    {
                        "id": 471,
                        "name": "delete performance type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 471
                        }
                    },
                    {
                        "id": 472,
                        "name": "manage form field",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 472
                        }
                    },
                    {
                        "id": 473,
                        "name": "create form field",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 473
                        }
                    },
                    {
                        "id": 474,
                        "name": "edit form field",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 474
                        }
                    },
                    {
                        "id": 475,
                        "name": "delete form field",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 475
                        }
                    },
                    {
                        "id": 476,
                        "name": "view form response",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 476
                        }
                    },
                    {
                        "id": 477,
                        "name": "create budget plan",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 477
                        }
                    },
                    {
                        "id": 478,
                        "name": "edit budget plan",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 478
                        }
                    },
                    {
                        "id": 479,
                        "name": "manage budget plan",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 479
                        }
                    },
                    {
                        "id": 480,
                        "name": "delete budget plan",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 480
                        }
                    },
                    {
                        "id": 481,
                        "name": "view budget plan",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 481
                        }
                    },
                    {
                        "id": 482,
                        "name": "manage warehouse",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 482
                        }
                    },
                    {
                        "id": 483,
                        "name": "create warehouse",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 483
                        }
                    },
                    {
                        "id": 484,
                        "name": "edit warehouse",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 484
                        }
                    },
                    {
                        "id": 485,
                        "name": "show warehouse",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 485
                        }
                    },
                    {
                        "id": 486,
                        "name": "delete warehouse",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 486
                        }
                    },
                    {
                        "id": 487,
                        "name": "manage purchase",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 487
                        }
                    },
                    {
                        "id": 488,
                        "name": "create purchase",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 488
                        }
                    },
                    {
                        "id": 489,
                        "name": "edit purchase",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 489
                        }
                    },
                    {
                        "id": 490,
                        "name": "show purchase",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 490
                        }
                    },
                    {
                        "id": 491,
                        "name": "delete purchase",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 491
                        }
                    },
                    {
                        "id": 492,
                        "name": "send purchase",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 492
                        }
                    },
                    {
                        "id": 493,
                        "name": "create payment purchase",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 493
                        }
                    },
                    {
                        "id": 494,
                        "name": "manage pos",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 494
                        }
                    },
                    {
                        "id": 495,
                        "name": "manage contract type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 495
                        }
                    },
                    {
                        "id": 496,
                        "name": "create contract type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 496
                        }
                    },
                    {
                        "id": 497,
                        "name": "edit contract type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 497
                        }
                    },
                    {
                        "id": 498,
                        "name": "delete contract type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 498
                        }
                    },
                    {
                        "id": 499,
                        "name": "manage contract",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 499
                        }
                    },
                    {
                        "id": 500,
                        "name": "create contract",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 500
                        }
                    },
                    {
                        "id": 501,
                        "name": "edit contract",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 501
                        }
                    },
                    {
                        "id": 502,
                        "name": "delete contract",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 502
                        }
                    },
                    {
                        "id": 503,
                        "name": "show contract",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 503
                        }
                    },
                    {
                        "id": 504,
                        "name": "create barcode",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 504
                        }
                    },
                    {
                        "id": 505,
                        "name": "create webhook",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 505
                        }
                    },
                    {
                        "id": 506,
                        "name": "edit webhook",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 506
                        }
                    },
                    {
                        "id": 507,
                        "name": "delete webhook",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:31.000000Z",
                        "updated_at": "2025-11-05T06:48:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 507
                        }
                    },
                    {
                        "id": 508,
                        "name": "manage verify user",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:32.000000Z",
                        "updated_at": "2025-11-05T06:48:32.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 508
                        }
                    },
                    {
                        "id": 509,
                        "name": "manage company settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:32.000000Z",
                        "updated_at": "2025-11-05T06:48:32.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 509
                        }
                    },
                    {
                        "id": 510,
                        "name": "manage audit_logs",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:32.000000Z",
                        "updated_at": "2025-11-05T06:48:32.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 510
                        }
                    },
                    {
                        "id": 511,
                        "name": "create audit_logs",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:32.000000Z",
                        "updated_at": "2025-11-05T06:48:32.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 511
                        }
                    },
                    {
                        "id": 512,
                        "name": "edit audit_logs",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:32.000000Z",
                        "updated_at": "2025-11-05T06:48:32.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 512
                        }
                    },
                    {
                        "id": 513,
                        "name": "show audit_logs",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:33.000000Z",
                        "updated_at": "2025-11-05T06:48:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 513
                        }
                    },
                    {
                        "id": 514,
                        "name": "delete audit_logs",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:33.000000Z",
                        "updated_at": "2025-11-05T06:48:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 514
                        }
                    },
                    {
                        "id": 518,
                        "name": "manage api",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:33.000000Z",
                        "updated_at": "2025-11-05T06:48:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 518
                        }
                    },
                    {
                        "id": 519,
                        "name": "show api",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:33.000000Z",
                        "updated_at": "2025-11-05T06:48:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 519
                        }
                    },
                    {
                        "id": 520,
                        "name": "create api",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:33.000000Z",
                        "updated_at": "2025-11-05T06:48:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 520
                        }
                    },
                    {
                        "id": 521,
                        "name": "edit api",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:33.000000Z",
                        "updated_at": "2025-11-05T06:48:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 521
                        }
                    },
                    {
                        "id": 522,
                        "name": "delete api",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:33.000000Z",
                        "updated_at": "2025-11-05T06:48:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 522
                        }
                    },
                    {
                        "id": 523,
                        "name": "show PFI",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:34.000000Z",
                        "updated_at": "2025-11-05T06:48:34.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 523
                        }
                    },
                    {
                        "id": 524,
                        "name": "manage customer settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:34.000000Z",
                        "updated_at": "2025-11-05T06:48:34.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 524
                        }
                    },
                    {
                        "id": 529,
                        "name": "manage vendor settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:35.000000Z",
                        "updated_at": "2025-11-05T06:48:35.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 529
                        }
                    },
                    {
                        "id": 530,
                        "name": "show vendor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:35.000000Z",
                        "updated_at": "2025-11-05T06:48:35.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 530
                        }
                    },
                    {
                        "id": 531,
                        "name": "show hrm reports",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:42.000000Z",
                        "updated_at": "2025-11-05T06:48:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 531
                        }
                    },
                    {
                        "id": 532,
                        "name": "show distributor dashboard",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:42.000000Z",
                        "updated_at": "2025-11-05T06:48:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 532
                        }
                    },
                    {
                        "id": 533,
                        "name": "show distributor report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:42.000000Z",
                        "updated_at": "2025-11-05T06:48:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 533
                        }
                    },
                    {
                        "id": 534,
                        "name": "manage employee system access",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:42.000000Z",
                        "updated_at": "2025-11-05T06:48:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 534
                        }
                    },
                    {
                        "id": 535,
                        "name": "manage employee card",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:42.000000Z",
                        "updated_at": "2025-11-05T06:48:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 535
                        }
                    },
                    {
                        "id": 536,
                        "name": "create employee card",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:42.000000Z",
                        "updated_at": "2025-11-05T06:48:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 536
                        }
                    },
                    {
                        "id": 537,
                        "name": "edit employee card",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:43.000000Z",
                        "updated_at": "2025-11-05T06:48:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 537
                        }
                    },
                    {
                        "id": 538,
                        "name": "delete employee card",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:43.000000Z",
                        "updated_at": "2025-11-05T06:48:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 538
                        }
                    },
                    {
                        "id": 539,
                        "name": "show items",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:43.000000Z",
                        "updated_at": "2025-11-05T06:48:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 539
                        }
                    },
                    {
                        "id": 540,
                        "name": "manage warehouse product",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:43.000000Z",
                        "updated_at": "2025-11-05T06:48:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 540
                        }
                    },
                    {
                        "id": 541,
                        "name": "show warehouse product",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:43.000000Z",
                        "updated_at": "2025-11-05T06:48:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 541
                        }
                    },
                    {
                        "id": 542,
                        "name": "create warehouse product",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:43.000000Z",
                        "updated_at": "2025-11-05T06:48:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 542
                        }
                    },
                    {
                        "id": 543,
                        "name": "delete warehouse product",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:43.000000Z",
                        "updated_at": "2025-11-05T06:48:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 543
                        }
                    },
                    {
                        "id": 544,
                        "name": "edit warehouse product",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:43.000000Z",
                        "updated_at": "2025-11-05T06:48:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 544
                        }
                    },
                    {
                        "id": 545,
                        "name": "manage petty cash status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:43.000000Z",
                        "updated_at": "2025-11-05T06:48:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 545
                        }
                    },
                    {
                        "id": 546,
                        "name": "show petty cash status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:43.000000Z",
                        "updated_at": "2025-11-05T06:48:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 546
                        }
                    },
                    {
                        "id": 547,
                        "name": "create petty cash status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:44.000000Z",
                        "updated_at": "2025-11-05T06:48:44.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 547
                        }
                    },
                    {
                        "id": 548,
                        "name": "delete petty cash status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:44.000000Z",
                        "updated_at": "2025-11-05T06:48:44.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 548
                        }
                    },
                    {
                        "id": 549,
                        "name": "edit petty cash status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:44.000000Z",
                        "updated_at": "2025-11-05T06:48:44.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 549
                        }
                    },
                    {
                        "id": 550,
                        "name": "manage stock adjustment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:44.000000Z",
                        "updated_at": "2025-11-05T06:48:44.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 550
                        }
                    },
                    {
                        "id": 551,
                        "name": "show inventory dashboard",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:44.000000Z",
                        "updated_at": "2025-11-05T06:48:44.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 551
                        }
                    },
                    {
                        "id": 552,
                        "name": "show inventory report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:44.000000Z",
                        "updated_at": "2025-11-05T06:48:44.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 552
                        }
                    },
                    {
                        "id": 553,
                        "name": "show asset dashboard",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:44.000000Z",
                        "updated_at": "2025-11-05T06:48:44.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 553
                        }
                    },
                    {
                        "id": 554,
                        "name": "show asset report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:44.000000Z",
                        "updated_at": "2025-11-05T06:48:44.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 554
                        }
                    },
                    {
                        "id": 555,
                        "name": "show stock adjustment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:44.000000Z",
                        "updated_at": "2025-11-05T06:48:44.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 555
                        }
                    },
                    {
                        "id": 556,
                        "name": "create stock adjustment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:45.000000Z",
                        "updated_at": "2025-11-05T06:48:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 556
                        }
                    },
                    {
                        "id": 557,
                        "name": "delete stock adjustment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:45.000000Z",
                        "updated_at": "2025-11-05T06:48:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 557
                        }
                    },
                    {
                        "id": 558,
                        "name": "edit stock adjustment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:45.000000Z",
                        "updated_at": "2025-11-05T06:48:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 558
                        }
                    },
                    {
                        "id": 559,
                        "name": "manage distributor settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:45.000000Z",
                        "updated_at": "2025-11-05T06:48:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 559
                        }
                    },
                    {
                        "id": 560,
                        "name": "manage distributor notification setting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:45.000000Z",
                        "updated_at": "2025-11-05T06:48:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 560
                        }
                    },
                    {
                        "id": 561,
                        "name": "manage distributor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:45.000000Z",
                        "updated_at": "2025-11-05T06:48:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 561
                        }
                    },
                    {
                        "id": 562,
                        "name": "show distributor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:45.000000Z",
                        "updated_at": "2025-11-05T06:48:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 562
                        }
                    },
                    {
                        "id": 563,
                        "name": "create distributor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:45.000000Z",
                        "updated_at": "2025-11-05T06:48:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 563
                        }
                    },
                    {
                        "id": 564,
                        "name": "delete distributor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:45.000000Z",
                        "updated_at": "2025-11-05T06:48:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 564
                        }
                    },
                    {
                        "id": 565,
                        "name": "edit distributor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:45.000000Z",
                        "updated_at": "2025-11-05T06:48:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 565
                        }
                    },
                    {
                        "id": 566,
                        "name": "manage loading instruction",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:46.000000Z",
                        "updated_at": "2025-11-05T06:48:46.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 566
                        }
                    },
                    {
                        "id": 567,
                        "name": "show loading instruction",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:46.000000Z",
                        "updated_at": "2025-11-05T06:48:46.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 567
                        }
                    },
                    {
                        "id": 568,
                        "name": "create loading instruction",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:46.000000Z",
                        "updated_at": "2025-11-05T06:48:46.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 568
                        }
                    },
                    {
                        "id": 569,
                        "name": "delete loading instruction",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:46.000000Z",
                        "updated_at": "2025-11-05T06:48:46.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 569
                        }
                    },
                    {
                        "id": 570,
                        "name": "edit loading instruction",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:46.000000Z",
                        "updated_at": "2025-11-05T06:48:46.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 570
                        }
                    },
                    {
                        "id": 571,
                        "name": "manage distributor type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:46.000000Z",
                        "updated_at": "2025-11-05T06:48:46.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 571
                        }
                    },
                    {
                        "id": 572,
                        "name": "show distributor type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:46.000000Z",
                        "updated_at": "2025-11-05T06:48:46.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 572
                        }
                    },
                    {
                        "id": 573,
                        "name": "create distributor type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:46.000000Z",
                        "updated_at": "2025-11-05T06:48:46.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 573
                        }
                    },
                    {
                        "id": 574,
                        "name": "delete distributor type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:46.000000Z",
                        "updated_at": "2025-11-05T06:48:46.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 574
                        }
                    },
                    {
                        "id": 575,
                        "name": "edit distributor type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:47.000000Z",
                        "updated_at": "2025-11-05T06:48:47.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 575
                        }
                    },
                    {
                        "id": 576,
                        "name": "manage distributor attachment type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:47.000000Z",
                        "updated_at": "2025-11-05T06:48:47.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 576
                        }
                    },
                    {
                        "id": 577,
                        "name": "show distributor attachment type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:47.000000Z",
                        "updated_at": "2025-11-05T06:48:47.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 577
                        }
                    },
                    {
                        "id": 578,
                        "name": "create distributor attachment type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:47.000000Z",
                        "updated_at": "2025-11-05T06:48:47.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 578
                        }
                    },
                    {
                        "id": 579,
                        "name": "delete distributor attachment type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:47.000000Z",
                        "updated_at": "2025-11-05T06:48:47.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 579
                        }
                    },
                    {
                        "id": 580,
                        "name": "edit distributor attachment type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:47.000000Z",
                        "updated_at": "2025-11-05T06:48:47.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 580
                        }
                    },
                    {
                        "id": 581,
                        "name": "manage distributor item",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:47.000000Z",
                        "updated_at": "2025-11-05T06:48:47.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 581
                        }
                    },
                    {
                        "id": 582,
                        "name": "show distributor item",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:47.000000Z",
                        "updated_at": "2025-11-05T06:48:47.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 582
                        }
                    },
                    {
                        "id": 583,
                        "name": "create distributor item",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:47.000000Z",
                        "updated_at": "2025-11-05T06:48:47.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 583
                        }
                    },
                    {
                        "id": 584,
                        "name": "delete distributor item",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:48.000000Z",
                        "updated_at": "2025-11-05T06:48:48.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 584
                        }
                    },
                    {
                        "id": 585,
                        "name": "edit distributor item",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:48.000000Z",
                        "updated_at": "2025-11-05T06:48:48.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 585
                        }
                    },
                    {
                        "id": 586,
                        "name": "manage distributor order",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:48.000000Z",
                        "updated_at": "2025-11-05T06:48:48.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 586
                        }
                    },
                    {
                        "id": 587,
                        "name": "show distributor order",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:48.000000Z",
                        "updated_at": "2025-11-05T06:48:48.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 587
                        }
                    },
                    {
                        "id": 588,
                        "name": "create distributor order",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:48.000000Z",
                        "updated_at": "2025-11-05T06:48:48.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 588
                        }
                    },
                    {
                        "id": 589,
                        "name": "delete distributor order",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:48.000000Z",
                        "updated_at": "2025-11-05T06:48:48.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 589
                        }
                    },
                    {
                        "id": 590,
                        "name": "edit distributor order",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:48.000000Z",
                        "updated_at": "2025-11-05T06:48:48.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 590
                        }
                    },
                    {
                        "id": 591,
                        "name": "manage reassigned distributor order",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:48.000000Z",
                        "updated_at": "2025-11-05T06:48:48.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 591
                        }
                    },
                    {
                        "id": 592,
                        "name": "manage wholesaler price",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:48.000000Z",
                        "updated_at": "2025-11-05T06:48:48.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 592
                        }
                    },
                    {
                        "id": 593,
                        "name": "show wholesaler price",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:49.000000Z",
                        "updated_at": "2025-11-05T06:48:49.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 593
                        }
                    },
                    {
                        "id": 594,
                        "name": "create wholesaler price",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:49.000000Z",
                        "updated_at": "2025-11-05T06:48:49.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 594
                        }
                    },
                    {
                        "id": 595,
                        "name": "delete wholesaler price",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:49.000000Z",
                        "updated_at": "2025-11-05T06:48:49.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 595
                        }
                    },
                    {
                        "id": 596,
                        "name": "edit wholesaler price",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:49.000000Z",
                        "updated_at": "2025-11-05T06:48:49.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 596
                        }
                    },
                    {
                        "id": 597,
                        "name": "manage super dealer zone",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:49.000000Z",
                        "updated_at": "2025-11-05T06:48:49.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 597
                        }
                    },
                    {
                        "id": 598,
                        "name": "show super dealer zone",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:49.000000Z",
                        "updated_at": "2025-11-05T06:48:49.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 598
                        }
                    },
                    {
                        "id": 599,
                        "name": "create super dealer zone",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:49.000000Z",
                        "updated_at": "2025-11-05T06:48:49.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 599
                        }
                    },
                    {
                        "id": 600,
                        "name": "delete super dealer zone",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:49.000000Z",
                        "updated_at": "2025-11-05T06:48:49.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 600
                        }
                    },
                    {
                        "id": 601,
                        "name": "edit super dealer zone",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:49.000000Z",
                        "updated_at": "2025-11-05T06:48:49.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 601
                        }
                    },
                    {
                        "id": 602,
                        "name": "manage asset",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:50.000000Z",
                        "updated_at": "2025-11-05T06:48:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 602
                        }
                    },
                    {
                        "id": 603,
                        "name": "show asset",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:50.000000Z",
                        "updated_at": "2025-11-05T06:48:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 603
                        }
                    },
                    {
                        "id": 604,
                        "name": "create asset",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:50.000000Z",
                        "updated_at": "2025-11-05T06:48:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 604
                        }
                    },
                    {
                        "id": 605,
                        "name": "delete asset",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:50.000000Z",
                        "updated_at": "2025-11-05T06:48:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 605
                        }
                    },
                    {
                        "id": 606,
                        "name": "edit asset",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:50.000000Z",
                        "updated_at": "2025-11-05T06:48:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 606
                        }
                    },
                    {
                        "id": 607,
                        "name": "show bank",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:50.000000Z",
                        "updated_at": "2025-11-05T06:48:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 607
                        }
                    },
                    {
                        "id": 608,
                        "name": "manage accessory",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:50.000000Z",
                        "updated_at": "2025-11-05T06:48:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 608
                        }
                    },
                    {
                        "id": 609,
                        "name": "show accessory",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:50.000000Z",
                        "updated_at": "2025-11-05T06:48:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 609
                        }
                    },
                    {
                        "id": 610,
                        "name": "create accessory",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:50.000000Z",
                        "updated_at": "2025-11-05T06:48:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 610
                        }
                    },
                    {
                        "id": 611,
                        "name": "delete accessory",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:50.000000Z",
                        "updated_at": "2025-11-05T06:48:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 611
                        }
                    },
                    {
                        "id": 612,
                        "name": "edit accessory",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:51.000000Z",
                        "updated_at": "2025-11-05T06:48:51.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 612
                        }
                    },
                    {
                        "id": 613,
                        "name": "manage database backup",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:51.000000Z",
                        "updated_at": "2025-11-05T06:48:51.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 613
                        }
                    },
                    {
                        "id": 614,
                        "name": "manage asset log",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:51.000000Z",
                        "updated_at": "2025-11-05T06:48:51.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 614
                        }
                    },
                    {
                        "id": 615,
                        "name": "show asset log",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:51.000000Z",
                        "updated_at": "2025-11-05T06:48:51.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 615
                        }
                    },
                    {
                        "id": 616,
                        "name": "manage asset label",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:51.000000Z",
                        "updated_at": "2025-11-05T06:48:51.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 616
                        }
                    },
                    {
                        "id": 617,
                        "name": "show asset label",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:51.000000Z",
                        "updated_at": "2025-11-05T06:48:51.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 617
                        }
                    },
                    {
                        "id": 618,
                        "name": "create asset label",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:51.000000Z",
                        "updated_at": "2025-11-05T06:48:51.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 618
                        }
                    },
                    {
                        "id": 619,
                        "name": "manage asset maintenance type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:51.000000Z",
                        "updated_at": "2025-11-05T06:48:51.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 619
                        }
                    },
                    {
                        "id": 620,
                        "name": "show asset maintenance type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:51.000000Z",
                        "updated_at": "2025-11-05T06:48:51.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 620
                        }
                    },
                    {
                        "id": 621,
                        "name": "create asset maintenance type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:52.000000Z",
                        "updated_at": "2025-11-05T06:48:52.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 621
                        }
                    },
                    {
                        "id": 622,
                        "name": "delete asset maintenance type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:52.000000Z",
                        "updated_at": "2025-11-05T06:48:52.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 622
                        }
                    },
                    {
                        "id": 623,
                        "name": "edit asset maintenance type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:52.000000Z",
                        "updated_at": "2025-11-05T06:48:52.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 623
                        }
                    },
                    {
                        "id": 624,
                        "name": "manage asset maintenance",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:52.000000Z",
                        "updated_at": "2025-11-05T06:48:52.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 624
                        }
                    },
                    {
                        "id": 625,
                        "name": "show asset maintenance",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:52.000000Z",
                        "updated_at": "2025-11-05T06:48:52.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 625
                        }
                    },
                    {
                        "id": 626,
                        "name": "create asset maintenance",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:52.000000Z",
                        "updated_at": "2025-11-05T06:48:52.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 626
                        }
                    },
                    {
                        "id": 627,
                        "name": "delete asset maintenance",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:52.000000Z",
                        "updated_at": "2025-11-05T06:48:52.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 627
                        }
                    },
                    {
                        "id": 628,
                        "name": "edit asset maintenance",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:52.000000Z",
                        "updated_at": "2025-11-05T06:48:52.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 628
                        }
                    },
                    {
                        "id": 629,
                        "name": "manage asset status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:52.000000Z",
                        "updated_at": "2025-11-05T06:48:52.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 629
                        }
                    },
                    {
                        "id": 630,
                        "name": "show asset status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:53.000000Z",
                        "updated_at": "2025-11-05T06:48:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 630
                        }
                    },
                    {
                        "id": 631,
                        "name": "create asset status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:53.000000Z",
                        "updated_at": "2025-11-05T06:48:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 631
                        }
                    },
                    {
                        "id": 632,
                        "name": "delete asset status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:53.000000Z",
                        "updated_at": "2025-11-05T06:48:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 632
                        }
                    },
                    {
                        "id": 633,
                        "name": "edit asset status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:53.000000Z",
                        "updated_at": "2025-11-05T06:48:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 633
                        }
                    },
                    {
                        "id": 634,
                        "name": "manage asset model",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:53.000000Z",
                        "updated_at": "2025-11-05T06:48:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 634
                        }
                    },
                    {
                        "id": 635,
                        "name": "show asset model",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:53.000000Z",
                        "updated_at": "2025-11-05T06:48:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 635
                        }
                    },
                    {
                        "id": 636,
                        "name": "create asset model",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:53.000000Z",
                        "updated_at": "2025-11-05T06:48:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 636
                        }
                    },
                    {
                        "id": 637,
                        "name": "delete asset model",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:53.000000Z",
                        "updated_at": "2025-11-05T06:48:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 637
                        }
                    },
                    {
                        "id": 638,
                        "name": "edit asset model",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:53.000000Z",
                        "updated_at": "2025-11-05T06:48:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 638
                        }
                    },
                    {
                        "id": 639,
                        "name": "manage asset category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:54.000000Z",
                        "updated_at": "2025-11-05T06:48:54.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 639
                        }
                    },
                    {
                        "id": 640,
                        "name": "show asset category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:54.000000Z",
                        "updated_at": "2025-11-05T06:48:54.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 640
                        }
                    },
                    {
                        "id": 641,
                        "name": "create asset category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:54.000000Z",
                        "updated_at": "2025-11-05T06:48:54.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 641
                        }
                    },
                    {
                        "id": 642,
                        "name": "delete asset category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:54.000000Z",
                        "updated_at": "2025-11-05T06:48:54.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 642
                        }
                    },
                    {
                        "id": 643,
                        "name": "edit asset category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:54.000000Z",
                        "updated_at": "2025-11-05T06:48:54.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 643
                        }
                    },
                    {
                        "id": 644,
                        "name": "manage asset manufacture",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:54.000000Z",
                        "updated_at": "2025-11-05T06:48:54.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 644
                        }
                    },
                    {
                        "id": 645,
                        "name": "show asset manufacture",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:54.000000Z",
                        "updated_at": "2025-11-05T06:48:54.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 645
                        }
                    },
                    {
                        "id": 646,
                        "name": "create asset manufacture",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:54.000000Z",
                        "updated_at": "2025-11-05T06:48:54.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 646
                        }
                    },
                    {
                        "id": 647,
                        "name": "delete asset manufacture",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:54.000000Z",
                        "updated_at": "2025-11-05T06:48:54.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 647
                        }
                    },
                    {
                        "id": 648,
                        "name": "edit asset manufacture",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:55.000000Z",
                        "updated_at": "2025-11-05T06:48:55.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 648
                        }
                    },
                    {
                        "id": 649,
                        "name": "manage asset depreciation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:55.000000Z",
                        "updated_at": "2025-11-05T06:48:55.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 649
                        }
                    },
                    {
                        "id": 650,
                        "name": "show asset depreciation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:55.000000Z",
                        "updated_at": "2025-11-05T06:48:55.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 650
                        }
                    },
                    {
                        "id": 651,
                        "name": "create asset depreciation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:55.000000Z",
                        "updated_at": "2025-11-05T06:48:55.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 651
                        }
                    },
                    {
                        "id": 652,
                        "name": "delete asset depreciation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:55.000000Z",
                        "updated_at": "2025-11-05T06:48:55.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 652
                        }
                    },
                    {
                        "id": 653,
                        "name": "edit asset depreciation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:55.000000Z",
                        "updated_at": "2025-11-05T06:48:55.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 653
                        }
                    },
                    {
                        "id": 654,
                        "name": "manage asset company",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:55.000000Z",
                        "updated_at": "2025-11-05T06:48:55.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 654
                        }
                    },
                    {
                        "id": 655,
                        "name": "show asset company",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:55.000000Z",
                        "updated_at": "2025-11-05T06:48:55.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 655
                        }
                    },
                    {
                        "id": 656,
                        "name": "create asset company",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:55.000000Z",
                        "updated_at": "2025-11-05T06:48:55.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 656
                        }
                    },
                    {
                        "id": 657,
                        "name": "delete asset company",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:56.000000Z",
                        "updated_at": "2025-11-05T06:48:56.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 657
                        }
                    },
                    {
                        "id": 658,
                        "name": "edit asset company",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:56.000000Z",
                        "updated_at": "2025-11-05T06:48:56.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 658
                        }
                    },
                    {
                        "id": 659,
                        "name": "manage asset location",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:56.000000Z",
                        "updated_at": "2025-11-05T06:48:56.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 659
                        }
                    },
                    {
                        "id": 660,
                        "name": "show asset location",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:56.000000Z",
                        "updated_at": "2025-11-05T06:48:56.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 660
                        }
                    },
                    {
                        "id": 661,
                        "name": "create asset location",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:56.000000Z",
                        "updated_at": "2025-11-05T06:48:56.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 661
                        }
                    },
                    {
                        "id": 662,
                        "name": "delete asset location",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:56.000000Z",
                        "updated_at": "2025-11-05T06:48:56.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 662
                        }
                    },
                    {
                        "id": 663,
                        "name": "edit asset location",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:56.000000Z",
                        "updated_at": "2025-11-05T06:48:56.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 663
                        }
                    },
                    {
                        "id": 664,
                        "name": "manage asset settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:57.000000Z",
                        "updated_at": "2025-11-05T06:48:57.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 664
                        }
                    },
                    {
                        "id": 665,
                        "name": "show asset settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:57.000000Z",
                        "updated_at": "2025-11-05T06:48:57.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 665
                        }
                    },
                    {
                        "id": 666,
                        "name": "create asset settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:57.000000Z",
                        "updated_at": "2025-11-05T06:48:57.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 666
                        }
                    },
                    {
                        "id": 667,
                        "name": "delete asset settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:57.000000Z",
                        "updated_at": "2025-11-05T06:48:57.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 667
                        }
                    },
                    {
                        "id": 668,
                        "name": "edit asset settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:57.000000Z",
                        "updated_at": "2025-11-05T06:48:57.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 668
                        }
                    },
                    {
                        "id": 669,
                        "name": "manage asset consumable",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:57.000000Z",
                        "updated_at": "2025-11-05T06:48:57.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 669
                        }
                    },
                    {
                        "id": 670,
                        "name": "show asset consumable",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:57.000000Z",
                        "updated_at": "2025-11-05T06:48:57.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 670
                        }
                    },
                    {
                        "id": 671,
                        "name": "create asset consumable",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:57.000000Z",
                        "updated_at": "2025-11-05T06:48:57.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 671
                        }
                    },
                    {
                        "id": 672,
                        "name": "delete asset consumable",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:58.000000Z",
                        "updated_at": "2025-11-05T06:48:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 672
                        }
                    },
                    {
                        "id": 673,
                        "name": "edit asset consumable",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:58.000000Z",
                        "updated_at": "2025-11-05T06:48:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 673
                        }
                    },
                    {
                        "id": 674,
                        "name": "manage asset component",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:58.000000Z",
                        "updated_at": "2025-11-05T06:48:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 674
                        }
                    },
                    {
                        "id": 675,
                        "name": "show asset component",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:58.000000Z",
                        "updated_at": "2025-11-05T06:48:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 675
                        }
                    },
                    {
                        "id": 676,
                        "name": "create asset component",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:58.000000Z",
                        "updated_at": "2025-11-05T06:48:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 676
                        }
                    },
                    {
                        "id": 677,
                        "name": "delete asset component",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:58.000000Z",
                        "updated_at": "2025-11-05T06:48:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 677
                        }
                    },
                    {
                        "id": 678,
                        "name": "edit asset component",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:58.000000Z",
                        "updated_at": "2025-11-05T06:48:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 678
                        }
                    },
                    {
                        "id": 679,
                        "name": "manage asset license",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:58.000000Z",
                        "updated_at": "2025-11-05T06:48:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 679
                        }
                    },
                    {
                        "id": 680,
                        "name": "show asset license",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:58.000000Z",
                        "updated_at": "2025-11-05T06:48:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 680
                        }
                    },
                    {
                        "id": 681,
                        "name": "create asset license",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:59.000000Z",
                        "updated_at": "2025-11-05T06:48:59.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 681
                        }
                    },
                    {
                        "id": 682,
                        "name": "delete asset license",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:59.000000Z",
                        "updated_at": "2025-11-05T06:48:59.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 682
                        }
                    },
                    {
                        "id": 683,
                        "name": "edit asset license",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:59.000000Z",
                        "updated_at": "2025-11-05T06:48:59.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 683
                        }
                    },
                    {
                        "id": 684,
                        "name": "manage asset accessory",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:59.000000Z",
                        "updated_at": "2025-11-05T06:48:59.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 684
                        }
                    },
                    {
                        "id": 685,
                        "name": "show asset accessory",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:59.000000Z",
                        "updated_at": "2025-11-05T06:48:59.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 685
                        }
                    },
                    {
                        "id": 686,
                        "name": "create asset accessory",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:59.000000Z",
                        "updated_at": "2025-11-05T06:48:59.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 686
                        }
                    },
                    {
                        "id": 687,
                        "name": "delete asset accessory",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:59.000000Z",
                        "updated_at": "2025-11-05T06:48:59.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 687
                        }
                    },
                    {
                        "id": 688,
                        "name": "edit asset accessory",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:59.000000Z",
                        "updated_at": "2025-11-05T06:48:59.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 688
                        }
                    },
                    {
                        "id": 689,
                        "name": "manage third part api",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:48:59.000000Z",
                        "updated_at": "2025-11-05T06:48:59.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 689
                        }
                    },
                    {
                        "id": 690,
                        "name": "show third part api",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:00.000000Z",
                        "updated_at": "2025-11-05T06:49:00.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 690
                        }
                    },
                    {
                        "id": 691,
                        "name": "create third part api",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:00.000000Z",
                        "updated_at": "2025-11-05T06:49:00.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 691
                        }
                    },
                    {
                        "id": 692,
                        "name": "manage stock transfer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:00.000000Z",
                        "updated_at": "2025-11-05T06:49:00.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 692
                        }
                    },
                    {
                        "id": 693,
                        "name": "show stock transfer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:00.000000Z",
                        "updated_at": "2025-11-05T06:49:00.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 693
                        }
                    },
                    {
                        "id": 694,
                        "name": "create stock transfer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:00.000000Z",
                        "updated_at": "2025-11-05T06:49:00.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 694
                        }
                    },
                    {
                        "id": 695,
                        "name": "delete stock transfer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:00.000000Z",
                        "updated_at": "2025-11-05T06:49:00.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 695
                        }
                    },
                    {
                        "id": 696,
                        "name": "edit stock transfer",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:00.000000Z",
                        "updated_at": "2025-11-05T06:49:00.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 696
                        }
                    },
                    {
                        "id": 697,
                        "name": "manage stock request approve",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:00.000000Z",
                        "updated_at": "2025-11-05T06:49:00.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 697
                        }
                    },
                    {
                        "id": 698,
                        "name": "manage stock transfer request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:01.000000Z",
                        "updated_at": "2025-11-05T06:49:01.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 698
                        }
                    },
                    {
                        "id": 699,
                        "name": "show stock transfer request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:01.000000Z",
                        "updated_at": "2025-11-05T06:49:01.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 699
                        }
                    },
                    {
                        "id": 700,
                        "name": "create stock transfer request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:01.000000Z",
                        "updated_at": "2025-11-05T06:49:01.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 700
                        }
                    },
                    {
                        "id": 701,
                        "name": "delete stock transfer request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:01.000000Z",
                        "updated_at": "2025-11-05T06:49:01.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 701
                        }
                    },
                    {
                        "id": 702,
                        "name": "edit stock transfer request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:01.000000Z",
                        "updated_at": "2025-11-05T06:49:01.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 702
                        }
                    },
                    {
                        "id": 703,
                        "name": "manage delivery note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:01.000000Z",
                        "updated_at": "2025-11-05T06:49:01.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 703
                        }
                    },
                    {
                        "id": 704,
                        "name": "show delivery note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:01.000000Z",
                        "updated_at": "2025-11-05T06:49:01.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 704
                        }
                    },
                    {
                        "id": 705,
                        "name": "create delivery note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:01.000000Z",
                        "updated_at": "2025-11-05T06:49:01.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 705
                        }
                    },
                    {
                        "id": 706,
                        "name": "delete delivery note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:01.000000Z",
                        "updated_at": "2025-11-05T06:49:01.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 706
                        }
                    },
                    {
                        "id": 707,
                        "name": "edit delivery note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:02.000000Z",
                        "updated_at": "2025-11-05T06:49:02.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 707
                        }
                    },
                    {
                        "id": 708,
                        "name": "manage goods receiving",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:02.000000Z",
                        "updated_at": "2025-11-05T06:49:02.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 708
                        }
                    },
                    {
                        "id": 709,
                        "name": "show goods receiving",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:02.000000Z",
                        "updated_at": "2025-11-05T06:49:02.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 709
                        }
                    },
                    {
                        "id": 710,
                        "name": "create goods receiving",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:02.000000Z",
                        "updated_at": "2025-11-05T06:49:02.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 710
                        }
                    },
                    {
                        "id": 711,
                        "name": "delete goods receiving",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:02.000000Z",
                        "updated_at": "2025-11-05T06:49:02.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 711
                        }
                    },
                    {
                        "id": 712,
                        "name": "edit goods receiving",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:02.000000Z",
                        "updated_at": "2025-11-05T06:49:02.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 712
                        }
                    },
                    {
                        "id": 713,
                        "name": "manage inventory settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:02.000000Z",
                        "updated_at": "2025-11-05T06:49:02.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 713
                        }
                    },
                    {
                        "id": 714,
                        "name": "show inventory settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:02.000000Z",
                        "updated_at": "2025-11-05T06:49:02.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 714
                        }
                    },
                    {
                        "id": 715,
                        "name": "create inventory settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:03.000000Z",
                        "updated_at": "2025-11-05T06:49:03.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 715
                        }
                    },
                    {
                        "id": 716,
                        "name": "delete inventory settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:03.000000Z",
                        "updated_at": "2025-11-05T06:49:03.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 716
                        }
                    },
                    {
                        "id": 717,
                        "name": "edit inventory settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:03.000000Z",
                        "updated_at": "2025-11-05T06:49:03.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 717
                        }
                    },
                    {
                        "id": 718,
                        "name": "manage delivery settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:03.000000Z",
                        "updated_at": "2025-11-05T06:49:03.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 718
                        }
                    },
                    {
                        "id": 719,
                        "name": "show delivery settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:03.000000Z",
                        "updated_at": "2025-11-05T06:49:03.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 719
                        }
                    },
                    {
                        "id": 720,
                        "name": "create delivery settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:03.000000Z",
                        "updated_at": "2025-11-05T06:49:03.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 720
                        }
                    },
                    {
                        "id": 721,
                        "name": "delete delivery settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:03.000000Z",
                        "updated_at": "2025-11-05T06:49:03.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 721
                        }
                    },
                    {
                        "id": 722,
                        "name": "edit delivery settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:03.000000Z",
                        "updated_at": "2025-11-05T06:49:03.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 722
                        }
                    },
                    {
                        "id": 723,
                        "name": "manage stock adjustment status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:04.000000Z",
                        "updated_at": "2025-11-05T06:49:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 723
                        }
                    },
                    {
                        "id": 724,
                        "name": "show stock adjustment status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:04.000000Z",
                        "updated_at": "2025-11-05T06:49:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 724
                        }
                    },
                    {
                        "id": 725,
                        "name": "create stock adjustment status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:04.000000Z",
                        "updated_at": "2025-11-05T06:49:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 725
                        }
                    },
                    {
                        "id": 726,
                        "name": "delete stock adjustment status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:04.000000Z",
                        "updated_at": "2025-11-05T06:49:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 726
                        }
                    },
                    {
                        "id": 727,
                        "name": "edit stock adjustment status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:04.000000Z",
                        "updated_at": "2025-11-05T06:49:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 727
                        }
                    },
                    {
                        "id": 728,
                        "name": "manage items_stock",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:04.000000Z",
                        "updated_at": "2025-11-05T06:49:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 728
                        }
                    },
                    {
                        "id": 729,
                        "name": "show other salary",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:04.000000Z",
                        "updated_at": "2025-11-05T06:49:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 729
                        }
                    },
                    {
                        "id": 730,
                        "name": "manage other salary payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:04.000000Z",
                        "updated_at": "2025-11-05T06:49:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 730
                        }
                    },
                    {
                        "id": 731,
                        "name": "manage other salary",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:04.000000Z",
                        "updated_at": "2025-11-05T06:49:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 731
                        }
                    },
                    {
                        "id": 732,
                        "name": "create other salary",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:05.000000Z",
                        "updated_at": "2025-11-05T06:49:05.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 732
                        }
                    },
                    {
                        "id": 733,
                        "name": "edit other salary",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:05.000000Z",
                        "updated_at": "2025-11-05T06:49:05.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 733
                        }
                    },
                    {
                        "id": 734,
                        "name": "delete other salary",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:05.000000Z",
                        "updated_at": "2025-11-05T06:49:05.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 734
                        }
                    },
                    {
                        "id": 735,
                        "name": "show salary advance",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:05.000000Z",
                        "updated_at": "2025-11-05T06:49:05.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 735
                        }
                    },
                    {
                        "id": 736,
                        "name": "manage salary advance payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:05.000000Z",
                        "updated_at": "2025-11-05T06:49:05.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 736
                        }
                    },
                    {
                        "id": 737,
                        "name": "manage salary advance",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:05.000000Z",
                        "updated_at": "2025-11-05T06:49:05.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 737
                        }
                    },
                    {
                        "id": 738,
                        "name": "create salary advance",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:05.000000Z",
                        "updated_at": "2025-11-05T06:49:05.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 738
                        }
                    },
                    {
                        "id": 739,
                        "name": "edit salary advance",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:06.000000Z",
                        "updated_at": "2025-11-05T06:49:06.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 739
                        }
                    },
                    {
                        "id": 740,
                        "name": "delete salary advance",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:06.000000Z",
                        "updated_at": "2025-11-05T06:49:06.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 740
                        }
                    },
                    {
                        "id": 741,
                        "name": "manage salary advance status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:06.000000Z",
                        "updated_at": "2025-11-05T06:49:06.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 741
                        }
                    },
                    {
                        "id": 742,
                        "name": "create salary advance status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:06.000000Z",
                        "updated_at": "2025-11-05T06:49:06.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 742
                        }
                    },
                    {
                        "id": 743,
                        "name": "edit salary advance status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:06.000000Z",
                        "updated_at": "2025-11-05T06:49:06.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 743
                        }
                    },
                    {
                        "id": 744,
                        "name": "delete salary advance status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:06.000000Z",
                        "updated_at": "2025-11-05T06:49:06.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 744
                        }
                    },
                    {
                        "id": 745,
                        "name": "manage vendor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:06.000000Z",
                        "updated_at": "2025-11-05T06:49:06.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 745
                        }
                    },
                    {
                        "id": 746,
                        "name": "create vendor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:06.000000Z",
                        "updated_at": "2025-11-05T06:49:06.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 746
                        }
                    },
                    {
                        "id": 747,
                        "name": "edit vendor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:07.000000Z",
                        "updated_at": "2025-11-05T06:49:07.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 747
                        }
                    },
                    {
                        "id": 748,
                        "name": "delete vendor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:07.000000Z",
                        "updated_at": "2025-11-05T06:49:07.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 748
                        }
                    },
                    {
                        "id": 749,
                        "name": "manage vendor client",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:07.000000Z",
                        "updated_at": "2025-11-05T06:49:07.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 749
                        }
                    },
                    {
                        "id": 750,
                        "name": "create vendor client",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:07.000000Z",
                        "updated_at": "2025-11-05T06:49:07.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 750
                        }
                    },
                    {
                        "id": 751,
                        "name": "edit vendor client",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:07.000000Z",
                        "updated_at": "2025-11-05T06:49:07.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 751
                        }
                    },
                    {
                        "id": 752,
                        "name": "delete vendor client",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:07.000000Z",
                        "updated_at": "2025-11-05T06:49:07.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 752
                        }
                    },
                    {
                        "id": 753,
                        "name": "show vendor client",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:07.000000Z",
                        "updated_at": "2025-11-05T06:49:07.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 753
                        }
                    },
                    {
                        "id": 754,
                        "name": "manage vendor category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:07.000000Z",
                        "updated_at": "2025-11-05T06:49:07.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 754
                        }
                    },
                    {
                        "id": 755,
                        "name": "create vendor category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:08.000000Z",
                        "updated_at": "2025-11-05T06:49:08.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 755
                        }
                    },
                    {
                        "id": 756,
                        "name": "edit vendor category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:08.000000Z",
                        "updated_at": "2025-11-05T06:49:08.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 756
                        }
                    },
                    {
                        "id": 757,
                        "name": "delete vendor category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:08.000000Z",
                        "updated_at": "2025-11-05T06:49:08.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 757
                        }
                    },
                    {
                        "id": 758,
                        "name": "show vendor category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:08.000000Z",
                        "updated_at": "2025-11-05T06:49:08.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 758
                        }
                    },
                    {
                        "id": 759,
                        "name": "manage vendor bank",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:08.000000Z",
                        "updated_at": "2025-11-05T06:49:08.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 759
                        }
                    },
                    {
                        "id": 760,
                        "name": "create vendor bank",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:08.000000Z",
                        "updated_at": "2025-11-05T06:49:08.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 760
                        }
                    },
                    {
                        "id": 761,
                        "name": "edit vendor bank",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:08.000000Z",
                        "updated_at": "2025-11-05T06:49:08.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 761
                        }
                    },
                    {
                        "id": 762,
                        "name": "delete vendor bank",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:08.000000Z",
                        "updated_at": "2025-11-05T06:49:08.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 762
                        }
                    },
                    {
                        "id": 763,
                        "name": "show vendor bank",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:09.000000Z",
                        "updated_at": "2025-11-05T06:49:09.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 763
                        }
                    },
                    {
                        "id": 764,
                        "name": "manage vendor attachment settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:09.000000Z",
                        "updated_at": "2025-11-05T06:49:09.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 764
                        }
                    },
                    {
                        "id": 765,
                        "name": "create vendor attachment settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:09.000000Z",
                        "updated_at": "2025-11-05T06:49:09.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 765
                        }
                    },
                    {
                        "id": 766,
                        "name": "edit vendor attachment settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:09.000000Z",
                        "updated_at": "2025-11-05T06:49:09.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 766
                        }
                    },
                    {
                        "id": 767,
                        "name": "delete vendor attachment settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:09.000000Z",
                        "updated_at": "2025-11-05T06:49:09.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 767
                        }
                    },
                    {
                        "id": 768,
                        "name": "show vendor attachment settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:09.000000Z",
                        "updated_at": "2025-11-05T06:49:09.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 768
                        }
                    },
                    {
                        "id": 769,
                        "name": "manage vendor payment term",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:09.000000Z",
                        "updated_at": "2025-11-05T06:49:09.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 769
                        }
                    },
                    {
                        "id": 770,
                        "name": "create vendor payment term",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:10.000000Z",
                        "updated_at": "2025-11-05T06:49:10.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 770
                        }
                    },
                    {
                        "id": 771,
                        "name": "edit vendor payment term",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:10.000000Z",
                        "updated_at": "2025-11-05T06:49:10.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 771
                        }
                    },
                    {
                        "id": 772,
                        "name": "delete vendor payment term",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:10.000000Z",
                        "updated_at": "2025-11-05T06:49:10.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 772
                        }
                    },
                    {
                        "id": 773,
                        "name": "show vendor payment term",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:10.000000Z",
                        "updated_at": "2025-11-05T06:49:10.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 773
                        }
                    },
                    {
                        "id": 774,
                        "name": "manage payment invoice",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:10.000000Z",
                        "updated_at": "2025-11-05T06:49:10.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 774
                        }
                    },
                    {
                        "id": 775,
                        "name": "show payment invoice",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:10.000000Z",
                        "updated_at": "2025-11-05T06:49:10.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 775
                        }
                    },
                    {
                        "id": 776,
                        "name": "edit payment invoice",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:10.000000Z",
                        "updated_at": "2025-11-05T06:49:10.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 776
                        }
                    },
                    {
                        "id": 777,
                        "name": "manage invoice status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:10.000000Z",
                        "updated_at": "2025-11-05T06:49:10.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 777
                        }
                    },
                    {
                        "id": 778,
                        "name": "manage PFI credit note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:11.000000Z",
                        "updated_at": "2025-11-05T06:49:11.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 778
                        }
                    },
                    {
                        "id": 779,
                        "name": "create PFI credit note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:11.000000Z",
                        "updated_at": "2025-11-05T06:49:11.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 779
                        }
                    },
                    {
                        "id": 780,
                        "name": "edit PFI credit note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:11.000000Z",
                        "updated_at": "2025-11-05T06:49:11.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 780
                        }
                    },
                    {
                        "id": 781,
                        "name": "delete PFI credit note",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:11.000000Z",
                        "updated_at": "2025-11-05T06:49:11.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 781
                        }
                    },
                    {
                        "id": 782,
                        "name": "manage PFI Status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:11.000000Z",
                        "updated_at": "2025-11-05T06:49:11.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 782
                        }
                    },
                    {
                        "id": 783,
                        "name": "manage PFI",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:11.000000Z",
                        "updated_at": "2025-11-05T06:49:11.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 783
                        }
                    },
                    {
                        "id": 784,
                        "name": "create PFI",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:12.000000Z",
                        "updated_at": "2025-11-05T06:49:12.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 784
                        }
                    },
                    {
                        "id": 785,
                        "name": "edit PFI",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:12.000000Z",
                        "updated_at": "2025-11-05T06:49:12.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 785
                        }
                    },
                    {
                        "id": 786,
                        "name": "delete PFI",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:12.000000Z",
                        "updated_at": "2025-11-05T06:49:12.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 786
                        }
                    },
                    {
                        "id": 787,
                        "name": "duplicate PFI",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:12.000000Z",
                        "updated_at": "2025-11-05T06:49:12.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 787
                        }
                    },
                    {
                        "id": 788,
                        "name": "send PFI",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:12.000000Z",
                        "updated_at": "2025-11-05T06:49:12.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 788
                        }
                    },
                    {
                        "id": 789,
                        "name": "manage PFI payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:12.000000Z",
                        "updated_at": "2025-11-05T06:49:12.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 789
                        }
                    },
                    {
                        "id": 790,
                        "name": "create PFI payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:13.000000Z",
                        "updated_at": "2025-11-05T06:49:13.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 790
                        }
                    },
                    {
                        "id": 791,
                        "name": "edit PFI payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:13.000000Z",
                        "updated_at": "2025-11-05T06:49:13.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 791
                        }
                    },
                    {
                        "id": 792,
                        "name": "delete PFI payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:13.000000Z",
                        "updated_at": "2025-11-05T06:49:13.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 792
                        }
                    },
                    {
                        "id": 793,
                        "name": "show PFI payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:13.000000Z",
                        "updated_at": "2025-11-05T06:49:13.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 793
                        }
                    },
                    {
                        "id": 794,
                        "name": "manage reminders",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:13.000000Z",
                        "updated_at": "2025-11-05T06:49:13.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 794
                        }
                    },
                    {
                        "id": 795,
                        "name": "manage lead reminder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:13.000000Z",
                        "updated_at": "2025-11-05T06:49:13.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 795
                        }
                    },
                    {
                        "id": 796,
                        "name": "create lead reminder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:13.000000Z",
                        "updated_at": "2025-11-05T06:49:13.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 796
                        }
                    },
                    {
                        "id": 797,
                        "name": "show lead reminder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:14.000000Z",
                        "updated_at": "2025-11-05T06:49:14.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 797
                        }
                    },
                    {
                        "id": 798,
                        "name": "edit lead reminder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:14.000000Z",
                        "updated_at": "2025-11-05T06:49:14.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 798
                        }
                    },
                    {
                        "id": 799,
                        "name": "delete lead reminder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:14.000000Z",
                        "updated_at": "2025-11-05T06:49:14.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 799
                        }
                    },
                    {
                        "id": 800,
                        "name": "manage deal reminder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:14.000000Z",
                        "updated_at": "2025-11-05T06:49:14.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 800
                        }
                    },
                    {
                        "id": 801,
                        "name": "create deal reminder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:14.000000Z",
                        "updated_at": "2025-11-05T06:49:14.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 801
                        }
                    },
                    {
                        "id": 802,
                        "name": "show deal reminder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:14.000000Z",
                        "updated_at": "2025-11-05T06:49:14.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 802
                        }
                    },
                    {
                        "id": 803,
                        "name": "edit deal reminder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:14.000000Z",
                        "updated_at": "2025-11-05T06:49:14.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 803
                        }
                    },
                    {
                        "id": 804,
                        "name": "delete deal reminder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:14.000000Z",
                        "updated_at": "2025-11-05T06:49:14.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 804
                        }
                    },
                    {
                        "id": 805,
                        "name": "view lead task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:15.000000Z",
                        "updated_at": "2025-11-05T06:49:15.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 805
                        }
                    },
                    {
                        "id": 806,
                        "name": "create lead task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:15.000000Z",
                        "updated_at": "2025-11-05T06:49:15.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 806
                        }
                    },
                    {
                        "id": 807,
                        "name": "edit lead task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:15.000000Z",
                        "updated_at": "2025-11-05T06:49:15.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 807
                        }
                    },
                    {
                        "id": 808,
                        "name": "delete lead task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:15.000000Z",
                        "updated_at": "2025-11-05T06:49:15.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 808
                        }
                    },
                    {
                        "id": 809,
                        "name": "manage employee type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:15.000000Z",
                        "updated_at": "2025-11-05T06:49:15.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 809
                        }
                    },
                    {
                        "id": 810,
                        "name": "create employee type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:15.000000Z",
                        "updated_at": "2025-11-05T06:49:15.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 810
                        }
                    },
                    {
                        "id": 811,
                        "name": "view employee type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:15.000000Z",
                        "updated_at": "2025-11-05T06:49:15.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 811
                        }
                    },
                    {
                        "id": 812,
                        "name": "edit employee type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:16.000000Z",
                        "updated_at": "2025-11-05T06:49:16.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 812
                        }
                    },
                    {
                        "id": 813,
                        "name": "delete employee type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:16.000000Z",
                        "updated_at": "2025-11-05T06:49:16.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 813
                        }
                    },
                    {
                        "id": 814,
                        "name": "manage employee bank",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:16.000000Z",
                        "updated_at": "2025-11-05T06:49:16.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 814
                        }
                    },
                    {
                        "id": 815,
                        "name": "create employee bank",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:16.000000Z",
                        "updated_at": "2025-11-05T06:49:16.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 815
                        }
                    },
                    {
                        "id": 816,
                        "name": "view employee bank",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:16.000000Z",
                        "updated_at": "2025-11-05T06:49:16.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 816
                        }
                    },
                    {
                        "id": 817,
                        "name": "edit employee bank",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:16.000000Z",
                        "updated_at": "2025-11-05T06:49:16.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 817
                        }
                    },
                    {
                        "id": 818,
                        "name": "delete employee bank",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:16.000000Z",
                        "updated_at": "2025-11-05T06:49:16.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 818
                        }
                    },
                    {
                        "id": 819,
                        "name": "manage employee kye",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:17.000000Z",
                        "updated_at": "2025-11-05T06:49:17.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 819
                        }
                    },
                    {
                        "id": 820,
                        "name": "view employee kye",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:17.000000Z",
                        "updated_at": "2025-11-05T06:49:17.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 820
                        }
                    },
                    {
                        "id": 821,
                        "name": "create employee kye",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:17.000000Z",
                        "updated_at": "2025-11-05T06:49:17.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 821
                        }
                    },
                    {
                        "id": 822,
                        "name": "edit employee kye",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:17.000000Z",
                        "updated_at": "2025-11-05T06:49:17.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 822
                        }
                    },
                    {
                        "id": 823,
                        "name": "delete employee kye",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:17.000000Z",
                        "updated_at": "2025-11-05T06:49:17.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 823
                        }
                    },
                    {
                        "id": 824,
                        "name": "view branch",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:17.000000Z",
                        "updated_at": "2025-11-05T06:49:17.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 824
                        }
                    },
                    {
                        "id": 825,
                        "name": "manage probation status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:17.000000Z",
                        "updated_at": "2025-11-05T06:49:17.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 825
                        }
                    },
                    {
                        "id": 826,
                        "name": "show probation status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:18.000000Z",
                        "updated_at": "2025-11-05T06:49:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 826
                        }
                    },
                    {
                        "id": 827,
                        "name": "create probation status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:18.000000Z",
                        "updated_at": "2025-11-05T06:49:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 827
                        }
                    },
                    {
                        "id": 828,
                        "name": "edit probation status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:18.000000Z",
                        "updated_at": "2025-11-05T06:49:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 828
                        }
                    },
                    {
                        "id": 829,
                        "name": "delete probation status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:18.000000Z",
                        "updated_at": "2025-11-05T06:49:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 829
                        }
                    },
                    {
                        "id": 830,
                        "name": "manage probation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:18.000000Z",
                        "updated_at": "2025-11-05T06:49:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 830
                        }
                    },
                    {
                        "id": 831,
                        "name": "show probation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:18.000000Z",
                        "updated_at": "2025-11-05T06:49:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 831
                        }
                    },
                    {
                        "id": 832,
                        "name": "create probation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:18.000000Z",
                        "updated_at": "2025-11-05T06:49:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 832
                        }
                    },
                    {
                        "id": 833,
                        "name": "edit probation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:19.000000Z",
                        "updated_at": "2025-11-05T06:49:19.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 833
                        }
                    },
                    {
                        "id": 834,
                        "name": "delete probation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:19.000000Z",
                        "updated_at": "2025-11-05T06:49:19.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 834
                        }
                    },
                    {
                        "id": 835,
                        "name": "manage kpi",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:19.000000Z",
                        "updated_at": "2025-11-05T06:49:19.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 835
                        }
                    },
                    {
                        "id": 836,
                        "name": "show kpi",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:19.000000Z",
                        "updated_at": "2025-11-05T06:49:19.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 836
                        }
                    },
                    {
                        "id": 837,
                        "name": "create kpi",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:19.000000Z",
                        "updated_at": "2025-11-05T06:49:19.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 837
                        }
                    },
                    {
                        "id": 838,
                        "name": "edit kpi",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:19.000000Z",
                        "updated_at": "2025-11-05T06:49:19.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 838
                        }
                    },
                    {
                        "id": 839,
                        "name": "delete kpi",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:20.000000Z",
                        "updated_at": "2025-11-05T06:49:20.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 839
                        }
                    },
                    {
                        "id": 840,
                        "name": "manage kpi title",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:20.000000Z",
                        "updated_at": "2025-11-05T06:49:20.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 840
                        }
                    },
                    {
                        "id": 841,
                        "name": "show kpi title",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:20.000000Z",
                        "updated_at": "2025-11-05T06:49:20.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 841
                        }
                    },
                    {
                        "id": 842,
                        "name": "create kpi title",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:20.000000Z",
                        "updated_at": "2025-11-05T06:49:20.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 842
                        }
                    },
                    {
                        "id": 843,
                        "name": "edit kpi title",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:20.000000Z",
                        "updated_at": "2025-11-05T06:49:20.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 843
                        }
                    },
                    {
                        "id": 844,
                        "name": "delete kpi title",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:21.000000Z",
                        "updated_at": "2025-11-05T06:49:21.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 844
                        }
                    },
                    {
                        "id": 845,
                        "name": "manage kpi objective",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:21.000000Z",
                        "updated_at": "2025-11-05T06:49:21.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 845
                        }
                    },
                    {
                        "id": 846,
                        "name": "show kpi objective",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:21.000000Z",
                        "updated_at": "2025-11-05T06:49:21.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 846
                        }
                    },
                    {
                        "id": 847,
                        "name": "create kpi objective",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:21.000000Z",
                        "updated_at": "2025-11-05T06:49:21.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 847
                        }
                    },
                    {
                        "id": 848,
                        "name": "edit kpi objective",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:21.000000Z",
                        "updated_at": "2025-11-05T06:49:21.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 848
                        }
                    },
                    {
                        "id": 849,
                        "name": "delete kpi objective",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:21.000000Z",
                        "updated_at": "2025-11-05T06:49:21.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 849
                        }
                    },
                    {
                        "id": 850,
                        "name": "manage hrm supervisor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:22.000000Z",
                        "updated_at": "2025-11-05T06:49:22.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 850
                        }
                    },
                    {
                        "id": 851,
                        "name": "show hrm supervisor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:22.000000Z",
                        "updated_at": "2025-11-05T06:49:22.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 851
                        }
                    },
                    {
                        "id": 852,
                        "name": "create hrm supervisor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:22.000000Z",
                        "updated_at": "2025-11-05T06:49:22.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 852
                        }
                    },
                    {
                        "id": 853,
                        "name": "edit hrm supervisor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:22.000000Z",
                        "updated_at": "2025-11-05T06:49:22.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 853
                        }
                    },
                    {
                        "id": 854,
                        "name": "delete hrm supervisor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:22.000000Z",
                        "updated_at": "2025-11-05T06:49:22.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 854
                        }
                    },
                    {
                        "id": 855,
                        "name": "manage kpi form",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:22.000000Z",
                        "updated_at": "2025-11-05T06:49:22.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 855
                        }
                    },
                    {
                        "id": 856,
                        "name": "show kpi form",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:23.000000Z",
                        "updated_at": "2025-11-05T06:49:23.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 856
                        }
                    },
                    {
                        "id": 857,
                        "name": "create kpi form",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:23.000000Z",
                        "updated_at": "2025-11-05T06:49:23.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 857
                        }
                    },
                    {
                        "id": 858,
                        "name": "edit kpi form",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:23.000000Z",
                        "updated_at": "2025-11-05T06:49:23.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 858
                        }
                    },
                    {
                        "id": 859,
                        "name": "delete kpi form",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:23.000000Z",
                        "updated_at": "2025-11-05T06:49:23.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 859
                        }
                    },
                    {
                        "id": 860,
                        "name": "manage leave status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:23.000000Z",
                        "updated_at": "2025-11-05T06:49:23.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 860
                        }
                    },
                    {
                        "id": 861,
                        "name": "view leave status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:23.000000Z",
                        "updated_at": "2025-11-05T06:49:23.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 861
                        }
                    },
                    {
                        "id": 862,
                        "name": "create leave status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:24.000000Z",
                        "updated_at": "2025-11-05T06:49:24.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 862
                        }
                    },
                    {
                        "id": 863,
                        "name": "edit leave status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:24.000000Z",
                        "updated_at": "2025-11-05T06:49:24.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 863
                        }
                    },
                    {
                        "id": 864,
                        "name": "delete leave status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:24.000000Z",
                        "updated_at": "2025-11-05T06:49:24.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 864
                        }
                    },
                    {
                        "id": 865,
                        "name": "create income tax rate",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:24.000000Z",
                        "updated_at": "2025-11-05T06:49:24.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 865
                        }
                    },
                    {
                        "id": 866,
                        "name": "edit income tax rate",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:24.000000Z",
                        "updated_at": "2025-11-05T06:49:24.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 866
                        }
                    },
                    {
                        "id": 867,
                        "name": "delete income tax rate",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:24.000000Z",
                        "updated_at": "2025-11-05T06:49:24.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 867
                        }
                    },
                    {
                        "id": 868,
                        "name": "manage vender dashboard",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:25.000000Z",
                        "updated_at": "2025-11-05T06:49:25.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 868
                        }
                    },
                    {
                        "id": 869,
                        "name": "manage overtime",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:25.000000Z",
                        "updated_at": "2025-11-05T06:49:25.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 869
                        }
                    },
                    {
                        "id": 870,
                        "name": "show overtime",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:25.000000Z",
                        "updated_at": "2025-11-05T06:49:25.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 870
                        }
                    },
                    {
                        "id": 871,
                        "name": "manage salary payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:25.000000Z",
                        "updated_at": "2025-11-05T06:49:25.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 871
                        }
                    },
                    {
                        "id": 872,
                        "name": "create salary payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:25.000000Z",
                        "updated_at": "2025-11-05T06:49:25.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 872
                        }
                    },
                    {
                        "id": 873,
                        "name": "edit salary payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:25.000000Z",
                        "updated_at": "2025-11-05T06:49:25.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 873
                        }
                    },
                    {
                        "id": 874,
                        "name": "edit pay slip",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:26.000000Z",
                        "updated_at": "2025-11-05T06:49:26.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 874
                        }
                    },
                    {
                        "id": 875,
                        "name": "delete pay slip",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:26.000000Z",
                        "updated_at": "2025-11-05T06:49:26.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 875
                        }
                    },
                    {
                        "id": 876,
                        "name": "show sales dashboard",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:26.000000Z",
                        "updated_at": "2025-11-05T06:49:26.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 876
                        }
                    },
                    {
                        "id": 877,
                        "name": "show sales report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:26.000000Z",
                        "updated_at": "2025-11-05T06:49:26.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 877
                        }
                    },
                    {
                        "id": 878,
                        "name": "show purchase dashboard",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:26.000000Z",
                        "updated_at": "2025-11-05T06:49:26.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 878
                        }
                    },
                    {
                        "id": 879,
                        "name": "show purchase report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:26.000000Z",
                        "updated_at": "2025-11-05T06:49:26.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 879
                        }
                    },
                    {
                        "id": 880,
                        "name": "show resignation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:27.000000Z",
                        "updated_at": "2025-11-05T06:49:27.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 880
                        }
                    },
                    {
                        "id": 881,
                        "name": "manage custom report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:27.000000Z",
                        "updated_at": "2025-11-05T06:49:27.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 881
                        }
                    },
                    {
                        "id": 882,
                        "name": "show custom report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:27.000000Z",
                        "updated_at": "2025-11-05T06:49:27.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 882
                        }
                    },
                    {
                        "id": 883,
                        "name": "create custom report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:27.000000Z",
                        "updated_at": "2025-11-05T06:49:27.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 883
                        }
                    },
                    {
                        "id": 884,
                        "name": "edit custom report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:27.000000Z",
                        "updated_at": "2025-11-05T06:49:27.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 884
                        }
                    },
                    {
                        "id": 885,
                        "name": "delete custom report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:27.000000Z",
                        "updated_at": "2025-11-05T06:49:27.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 885
                        }
                    },
                    {
                        "id": 886,
                        "name": "manage connect email",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:28.000000Z",
                        "updated_at": "2025-11-05T06:49:28.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 886
                        }
                    },
                    {
                        "id": 887,
                        "name": "show connect email",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:28.000000Z",
                        "updated_at": "2025-11-05T06:49:28.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 887
                        }
                    },
                    {
                        "id": 888,
                        "name": "create connect email",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:28.000000Z",
                        "updated_at": "2025-11-05T06:49:28.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 888
                        }
                    },
                    {
                        "id": 889,
                        "name": "edit connect email",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:28.000000Z",
                        "updated_at": "2025-11-05T06:49:28.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 889
                        }
                    },
                    {
                        "id": 890,
                        "name": "edit statutory deduction",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:28.000000Z",
                        "updated_at": "2025-11-05T06:49:28.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 890
                        }
                    },
                    {
                        "id": 891,
                        "name": "create statutory deduction",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:28.000000Z",
                        "updated_at": "2025-11-05T06:49:28.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 891
                        }
                    },
                    {
                        "id": 892,
                        "name": "delete statutory deduction",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:29.000000Z",
                        "updated_at": "2025-11-05T06:49:29.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 892
                        }
                    },
                    {
                        "id": 893,
                        "name": "manage statutory deduction",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:29.000000Z",
                        "updated_at": "2025-11-05T06:49:29.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 893
                        }
                    },
                    {
                        "id": 894,
                        "name": "show announcement",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:29.000000Z",
                        "updated_at": "2025-11-05T06:49:29.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 894
                        }
                    },
                    {
                        "id": 895,
                        "name": "show leave",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:29.000000Z",
                        "updated_at": "2025-11-05T06:49:29.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 895
                        }
                    },
                    {
                        "id": 896,
                        "name": "manage hrm settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:29.000000Z",
                        "updated_at": "2025-11-05T06:49:29.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 896
                        }
                    },
                    {
                        "id": 897,
                        "name": "create hrm settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:29.000000Z",
                        "updated_at": "2025-11-05T06:49:29.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 897
                        }
                    },
                    {
                        "id": 898,
                        "name": "manage matter",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:30.000000Z",
                        "updated_at": "2025-11-05T06:49:30.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 898
                        }
                    },
                    {
                        "id": 899,
                        "name": "create matter",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:30.000000Z",
                        "updated_at": "2025-11-05T06:49:30.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 899
                        }
                    },
                    {
                        "id": 900,
                        "name": "view matter",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:30.000000Z",
                        "updated_at": "2025-11-05T06:49:30.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 900
                        }
                    },
                    {
                        "id": 901,
                        "name": "edit matter",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:30.000000Z",
                        "updated_at": "2025-11-05T06:49:30.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 901
                        }
                    },
                    {
                        "id": 902,
                        "name": "delete matter",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:30.000000Z",
                        "updated_at": "2025-11-05T06:49:30.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 902
                        }
                    },
                    {
                        "id": 903,
                        "name": "share matter",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:31.000000Z",
                        "updated_at": "2025-11-05T06:49:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 903
                        }
                    },
                    {
                        "id": 904,
                        "name": "manage matter stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:31.000000Z",
                        "updated_at": "2025-11-05T06:49:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 904
                        }
                    },
                    {
                        "id": 905,
                        "name": "create matter stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:31.000000Z",
                        "updated_at": "2025-11-05T06:49:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 905
                        }
                    },
                    {
                        "id": 906,
                        "name": "edit matter stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:31.000000Z",
                        "updated_at": "2025-11-05T06:49:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 906
                        }
                    },
                    {
                        "id": 907,
                        "name": "delete matter stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:31.000000Z",
                        "updated_at": "2025-11-05T06:49:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 907
                        }
                    },
                    {
                        "id": 908,
                        "name": "manage matter task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:31.000000Z",
                        "updated_at": "2025-11-05T06:49:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 908
                        }
                    },
                    {
                        "id": 909,
                        "name": "create matter task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:32.000000Z",
                        "updated_at": "2025-11-05T06:49:32.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 909
                        }
                    },
                    {
                        "id": 910,
                        "name": "edit matter task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:32.000000Z",
                        "updated_at": "2025-11-05T06:49:32.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 910
                        }
                    },
                    {
                        "id": 911,
                        "name": "view matter task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:32.000000Z",
                        "updated_at": "2025-11-05T06:49:32.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 911
                        }
                    },
                    {
                        "id": 912,
                        "name": "delete matter task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:32.000000Z",
                        "updated_at": "2025-11-05T06:49:32.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 912
                        }
                    },
                    {
                        "id": 913,
                        "name": "manage project settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:32.000000Z",
                        "updated_at": "2025-11-05T06:49:32.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 913
                        }
                    },
                    {
                        "id": 914,
                        "name": "manage matter task stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:32.000000Z",
                        "updated_at": "2025-11-05T06:49:32.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 914
                        }
                    },
                    {
                        "id": 915,
                        "name": "create matter task stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:33.000000Z",
                        "updated_at": "2025-11-05T06:49:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 915
                        }
                    },
                    {
                        "id": 916,
                        "name": "edit matter task stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:33.000000Z",
                        "updated_at": "2025-11-05T06:49:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 916
                        }
                    },
                    {
                        "id": 917,
                        "name": "delete matter task stage",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:33.000000Z",
                        "updated_at": "2025-11-05T06:49:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 917
                        }
                    },
                    {
                        "id": 918,
                        "name": "manage matter settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:33.000000Z",
                        "updated_at": "2025-11-05T06:49:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 918
                        }
                    },
                    {
                        "id": 919,
                        "name": "manage items settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:33.000000Z",
                        "updated_at": "2025-11-05T06:49:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 919
                        }
                    },
                    {
                        "id": 920,
                        "name": "manage contract settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:33.000000Z",
                        "updated_at": "2025-11-05T06:49:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 920
                        }
                    },
                    {
                        "id": 921,
                        "name": "manage contract status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:34.000000Z",
                        "updated_at": "2025-11-05T06:49:34.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 921
                        }
                    },
                    {
                        "id": 922,
                        "name": "create contract status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:34.000000Z",
                        "updated_at": "2025-11-05T06:49:34.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 922
                        }
                    },
                    {
                        "id": 923,
                        "name": "edit contract status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:34.000000Z",
                        "updated_at": "2025-11-05T06:49:34.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 923
                        }
                    },
                    {
                        "id": 924,
                        "name": "delete contract status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:34.000000Z",
                        "updated_at": "2025-11-05T06:49:34.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 924
                        }
                    },
                    {
                        "id": 925,
                        "name": "show contract status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:34.000000Z",
                        "updated_at": "2025-11-05T06:49:34.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 925
                        }
                    },
                    {
                        "id": 926,
                        "name": "show logistic dashboard",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:34.000000Z",
                        "updated_at": "2025-11-05T06:49:34.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 926
                        }
                    },
                    {
                        "id": 927,
                        "name": "show logistic report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:35.000000Z",
                        "updated_at": "2025-11-05T06:49:35.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 927
                        }
                    },
                    {
                        "id": 928,
                        "name": "manage request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:35.000000Z",
                        "updated_at": "2025-11-05T06:49:35.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 928
                        }
                    },
                    {
                        "id": 929,
                        "name": "create request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:35.000000Z",
                        "updated_at": "2025-11-05T06:49:35.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 929
                        }
                    },
                    {
                        "id": 930,
                        "name": "edit request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:35.000000Z",
                        "updated_at": "2025-11-05T06:49:35.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 930
                        }
                    },
                    {
                        "id": 931,
                        "name": "show request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:35.000000Z",
                        "updated_at": "2025-11-05T06:49:35.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 931
                        }
                    },
                    {
                        "id": 932,
                        "name": "delete request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:35.000000Z",
                        "updated_at": "2025-11-05T06:49:35.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 932
                        }
                    },
                    {
                        "id": 933,
                        "name": "manage budget_matrix",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:36.000000Z",
                        "updated_at": "2025-11-05T06:49:36.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 933
                        }
                    },
                    {
                        "id": 934,
                        "name": "create budget_matrix",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:36.000000Z",
                        "updated_at": "2025-11-05T06:49:36.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 934
                        }
                    },
                    {
                        "id": 935,
                        "name": "edit budget_matrix",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:36.000000Z",
                        "updated_at": "2025-11-05T06:49:36.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 935
                        }
                    },
                    {
                        "id": 936,
                        "name": "show budget_matrix",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:36.000000Z",
                        "updated_at": "2025-11-05T06:49:36.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 936
                        }
                    },
                    {
                        "id": 937,
                        "name": "delete budget_matrix",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:36.000000Z",
                        "updated_at": "2025-11-05T06:49:36.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 937
                        }
                    },
                    {
                        "id": 938,
                        "name": "manage orders",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:37.000000Z",
                        "updated_at": "2025-11-05T06:49:37.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 938
                        }
                    },
                    {
                        "id": 939,
                        "name": "create orders invoice",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:37.000000Z",
                        "updated_at": "2025-11-05T06:49:37.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 939
                        }
                    },
                    {
                        "id": 940,
                        "name": "create orders",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:37.000000Z",
                        "updated_at": "2025-11-05T06:49:37.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 940
                        }
                    },
                    {
                        "id": 941,
                        "name": "edit orders",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:37.000000Z",
                        "updated_at": "2025-11-05T06:49:37.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 941
                        }
                    },
                    {
                        "id": 942,
                        "name": "show orders",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:37.000000Z",
                        "updated_at": "2025-11-05T06:49:37.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 942
                        }
                    },
                    {
                        "id": 943,
                        "name": "delete orders",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:37.000000Z",
                        "updated_at": "2025-11-05T06:49:37.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 943
                        }
                    },
                    {
                        "id": 944,
                        "name": "manage price list",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:38.000000Z",
                        "updated_at": "2025-11-05T06:49:38.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 944
                        }
                    },
                    {
                        "id": 945,
                        "name": "manage trip",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:38.000000Z",
                        "updated_at": "2025-11-05T06:49:38.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 945
                        }
                    },
                    {
                        "id": 946,
                        "name": "create trip",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:38.000000Z",
                        "updated_at": "2025-11-05T06:49:38.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 946
                        }
                    },
                    {
                        "id": 947,
                        "name": "edit trip",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:38.000000Z",
                        "updated_at": "2025-11-05T06:49:38.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 947
                        }
                    },
                    {
                        "id": 948,
                        "name": "show trip",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:38.000000Z",
                        "updated_at": "2025-11-05T06:49:38.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 948
                        }
                    },
                    {
                        "id": 949,
                        "name": "delete trip",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:39.000000Z",
                        "updated_at": "2025-11-05T06:49:39.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 949
                        }
                    },
                    {
                        "id": 950,
                        "name": "manage journey",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:39.000000Z",
                        "updated_at": "2025-11-05T06:49:39.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 950
                        }
                    },
                    {
                        "id": 951,
                        "name": "create journey",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:39.000000Z",
                        "updated_at": "2025-11-05T06:49:39.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 951
                        }
                    },
                    {
                        "id": 952,
                        "name": "edit journey",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:39.000000Z",
                        "updated_at": "2025-11-05T06:49:39.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 952
                        }
                    },
                    {
                        "id": 953,
                        "name": "show journey",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:39.000000Z",
                        "updated_at": "2025-11-05T06:49:39.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 953
                        }
                    },
                    {
                        "id": 954,
                        "name": "delete journey",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:40.000000Z",
                        "updated_at": "2025-11-05T06:49:40.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 954
                        }
                    },
                    {
                        "id": 955,
                        "name": "manage journey status change",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:40.000000Z",
                        "updated_at": "2025-11-05T06:49:40.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 955
                        }
                    },
                    {
                        "id": 956,
                        "name": "manage vehicle",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:40.000000Z",
                        "updated_at": "2025-11-05T06:49:40.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 956
                        }
                    },
                    {
                        "id": 957,
                        "name": "create vehicle",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:40.000000Z",
                        "updated_at": "2025-11-05T06:49:40.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 957
                        }
                    },
                    {
                        "id": 958,
                        "name": "edit vehicle",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:41.000000Z",
                        "updated_at": "2025-11-05T06:49:41.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 958
                        }
                    },
                    {
                        "id": 959,
                        "name": "show vehicle",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:41.000000Z",
                        "updated_at": "2025-11-05T06:49:41.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 959
                        }
                    },
                    {
                        "id": 960,
                        "name": "delete vehicle",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:41.000000Z",
                        "updated_at": "2025-11-05T06:49:41.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 960
                        }
                    },
                    {
                        "id": 961,
                        "name": "manage manifest report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:41.000000Z",
                        "updated_at": "2025-11-05T06:49:41.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 961
                        }
                    },
                    {
                        "id": 962,
                        "name": "create manifest report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:41.000000Z",
                        "updated_at": "2025-11-05T06:49:41.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 962
                        }
                    },
                    {
                        "id": 963,
                        "name": "edit manifest report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:41.000000Z",
                        "updated_at": "2025-11-05T06:49:41.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 963
                        }
                    },
                    {
                        "id": 964,
                        "name": "show manifest report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:42.000000Z",
                        "updated_at": "2025-11-05T06:49:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 964
                        }
                    },
                    {
                        "id": 965,
                        "name": "delete manifest report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:42.000000Z",
                        "updated_at": "2025-11-05T06:49:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 965
                        }
                    },
                    {
                        "id": 966,
                        "name": "manage cash report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:42.000000Z",
                        "updated_at": "2025-11-05T06:49:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 966
                        }
                    },
                    {
                        "id": 967,
                        "name": "show cash report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:42.000000Z",
                        "updated_at": "2025-11-05T06:49:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 967
                        }
                    },
                    {
                        "id": 968,
                        "name": "manage order report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:42.000000Z",
                        "updated_at": "2025-11-05T06:49:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 968
                        }
                    },
                    {
                        "id": 969,
                        "name": "show order report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:42.000000Z",
                        "updated_at": "2025-11-05T06:49:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 969
                        }
                    },
                    {
                        "id": 970,
                        "name": "manage sales report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:43.000000Z",
                        "updated_at": "2025-11-05T06:49:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 970
                        }
                    },
                    {
                        "id": 971,
                        "name": "manage aging report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:43.000000Z",
                        "updated_at": "2025-11-05T06:49:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 971
                        }
                    },
                    {
                        "id": 972,
                        "name": "show aging report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:43.000000Z",
                        "updated_at": "2025-11-05T06:49:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 972
                        }
                    },
                    {
                        "id": 973,
                        "name": "manage statement of account",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:43.000000Z",
                        "updated_at": "2025-11-05T06:49:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 973
                        }
                    },
                    {
                        "id": 974,
                        "name": "show statement of account",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:43.000000Z",
                        "updated_at": "2025-11-05T06:49:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 974
                        }
                    },
                    {
                        "id": 975,
                        "name": "manage vehicle_assignment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:43.000000Z",
                        "updated_at": "2025-11-05T06:49:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 975
                        }
                    },
                    {
                        "id": 976,
                        "name": "create vehicle_assignment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:44.000000Z",
                        "updated_at": "2025-11-05T06:49:44.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 976
                        }
                    },
                    {
                        "id": 977,
                        "name": "edit vehicle_assignment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:44.000000Z",
                        "updated_at": "2025-11-05T06:49:44.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 977
                        }
                    },
                    {
                        "id": 978,
                        "name": "show vehicle_assignment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:44.000000Z",
                        "updated_at": "2025-11-05T06:49:44.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 978
                        }
                    },
                    {
                        "id": 979,
                        "name": "delete vehicle_assignment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:44.000000Z",
                        "updated_at": "2025-11-05T06:49:44.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 979
                        }
                    },
                    {
                        "id": 980,
                        "name": "manage coordinate",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:44.000000Z",
                        "updated_at": "2025-11-05T06:49:44.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 980
                        }
                    },
                    {
                        "id": 981,
                        "name": "create coordinate",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:45.000000Z",
                        "updated_at": "2025-11-05T06:49:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 981
                        }
                    },
                    {
                        "id": 982,
                        "name": "edit coordinate",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:45.000000Z",
                        "updated_at": "2025-11-05T06:49:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 982
                        }
                    },
                    {
                        "id": 983,
                        "name": "show coordinate",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:45.000000Z",
                        "updated_at": "2025-11-05T06:49:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 983
                        }
                    },
                    {
                        "id": 984,
                        "name": "delete coordinate",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:45.000000Z",
                        "updated_at": "2025-11-05T06:49:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 984
                        }
                    },
                    {
                        "id": 985,
                        "name": "manage meter_history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:45.000000Z",
                        "updated_at": "2025-11-05T06:49:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 985
                        }
                    },
                    {
                        "id": 986,
                        "name": "create meter_history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:45.000000Z",
                        "updated_at": "2025-11-05T06:49:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 986
                        }
                    },
                    {
                        "id": 987,
                        "name": "edit meter_history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:46.000000Z",
                        "updated_at": "2025-11-05T06:49:46.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 987
                        }
                    },
                    {
                        "id": 988,
                        "name": "show meter_history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:46.000000Z",
                        "updated_at": "2025-11-05T06:49:46.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 988
                        }
                    },
                    {
                        "id": 989,
                        "name": "delete meter_history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:46.000000Z",
                        "updated_at": "2025-11-05T06:49:46.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 989
                        }
                    },
                    {
                        "id": 990,
                        "name": "manage expense_history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:46.000000Z",
                        "updated_at": "2025-11-05T06:49:46.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 990
                        }
                    },
                    {
                        "id": 991,
                        "name": "create expense_history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:46.000000Z",
                        "updated_at": "2025-11-05T06:49:46.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 991
                        }
                    },
                    {
                        "id": 992,
                        "name": "edit expense_history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:47.000000Z",
                        "updated_at": "2025-11-05T06:49:47.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 992
                        }
                    },
                    {
                        "id": 993,
                        "name": "show expense_history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:47.000000Z",
                        "updated_at": "2025-11-05T06:49:47.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 993
                        }
                    },
                    {
                        "id": 994,
                        "name": "delete expense_history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:47.000000Z",
                        "updated_at": "2025-11-05T06:49:47.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 994
                        }
                    },
                    {
                        "id": 995,
                        "name": "manage routes",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:47.000000Z",
                        "updated_at": "2025-11-05T06:49:47.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 995
                        }
                    },
                    {
                        "id": 996,
                        "name": "create routes",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:48.000000Z",
                        "updated_at": "2025-11-05T06:49:48.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 996
                        }
                    },
                    {
                        "id": 997,
                        "name": "edit routes",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:48.000000Z",
                        "updated_at": "2025-11-05T06:49:48.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 997
                        }
                    },
                    {
                        "id": 998,
                        "name": "show routes",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:48.000000Z",
                        "updated_at": "2025-11-05T06:49:48.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 998
                        }
                    },
                    {
                        "id": 999,
                        "name": "delete routes",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:48.000000Z",
                        "updated_at": "2025-11-05T06:49:48.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 999
                        }
                    },
                    {
                        "id": 1000,
                        "name": "manage inventory",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:48.000000Z",
                        "updated_at": "2025-11-05T06:49:48.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1000
                        }
                    },
                    {
                        "id": 1001,
                        "name": "create inventory",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:49.000000Z",
                        "updated_at": "2025-11-05T06:49:49.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1001
                        }
                    },
                    {
                        "id": 1002,
                        "name": "edit inventory",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:49.000000Z",
                        "updated_at": "2025-11-05T06:49:49.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1002
                        }
                    },
                    {
                        "id": 1003,
                        "name": "show inventory",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:49.000000Z",
                        "updated_at": "2025-11-05T06:49:49.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1003
                        }
                    },
                    {
                        "id": 1004,
                        "name": "delete inventory",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:49.000000Z",
                        "updated_at": "2025-11-05T06:49:49.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1004
                        }
                    },
                    {
                        "id": 1005,
                        "name": "manage machine",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:50.000000Z",
                        "updated_at": "2025-11-05T06:49:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1005
                        }
                    },
                    {
                        "id": 1006,
                        "name": "create machine",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:50.000000Z",
                        "updated_at": "2025-11-05T06:49:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1006
                        }
                    },
                    {
                        "id": 1007,
                        "name": "edit machine",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:50.000000Z",
                        "updated_at": "2025-11-05T06:49:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1007
                        }
                    },
                    {
                        "id": 1008,
                        "name": "show machine",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:50.000000Z",
                        "updated_at": "2025-11-05T06:49:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1008
                        }
                    },
                    {
                        "id": 1009,
                        "name": "delete machine",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:50.000000Z",
                        "updated_at": "2025-11-05T06:49:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1009
                        }
                    },
                    {
                        "id": 1010,
                        "name": "manage jobcard close",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:51.000000Z",
                        "updated_at": "2025-11-05T06:49:51.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1010
                        }
                    },
                    {
                        "id": 1011,
                        "name": "manage jobcard status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:51.000000Z",
                        "updated_at": "2025-11-05T06:49:51.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1011
                        }
                    },
                    {
                        "id": 1012,
                        "name": "create jobcard status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:51.000000Z",
                        "updated_at": "2025-11-05T06:49:51.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1012
                        }
                    },
                    {
                        "id": 1013,
                        "name": "edit jobcard status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:51.000000Z",
                        "updated_at": "2025-11-05T06:49:51.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1013
                        }
                    },
                    {
                        "id": 1014,
                        "name": "show jobcard status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:51.000000Z",
                        "updated_at": "2025-11-05T06:49:51.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1014
                        }
                    },
                    {
                        "id": 1015,
                        "name": "delete jobcard status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:52.000000Z",
                        "updated_at": "2025-11-05T06:49:52.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1015
                        }
                    },
                    {
                        "id": 1016,
                        "name": "manage inspection",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:52.000000Z",
                        "updated_at": "2025-11-05T06:49:52.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1016
                        }
                    },
                    {
                        "id": 1017,
                        "name": "create inspection",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:52.000000Z",
                        "updated_at": "2025-11-05T06:49:52.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1017
                        }
                    },
                    {
                        "id": 1018,
                        "name": "edit inspection",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:52.000000Z",
                        "updated_at": "2025-11-05T06:49:52.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1018
                        }
                    },
                    {
                        "id": 1019,
                        "name": "show inspection",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:52.000000Z",
                        "updated_at": "2025-11-05T06:49:52.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1019
                        }
                    },
                    {
                        "id": 1020,
                        "name": "delete inspection",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:53.000000Z",
                        "updated_at": "2025-11-05T06:49:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1020
                        }
                    },
                    {
                        "id": 1021,
                        "name": "manage fuel",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:53.000000Z",
                        "updated_at": "2025-11-05T06:49:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1021
                        }
                    },
                    {
                        "id": 1022,
                        "name": "create fuel",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:53.000000Z",
                        "updated_at": "2025-11-05T06:49:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1022
                        }
                    },
                    {
                        "id": 1023,
                        "name": "edit fuel",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:53.000000Z",
                        "updated_at": "2025-11-05T06:49:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1023
                        }
                    },
                    {
                        "id": 1024,
                        "name": "show fuel",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:53.000000Z",
                        "updated_at": "2025-11-05T06:49:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1024
                        }
                    },
                    {
                        "id": 1025,
                        "name": "delete fuel",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:53.000000Z",
                        "updated_at": "2025-11-05T06:49:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1025
                        }
                    },
                    {
                        "id": 1026,
                        "name": "manage job_card",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:54.000000Z",
                        "updated_at": "2025-11-05T06:49:54.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1026
                        }
                    },
                    {
                        "id": 1027,
                        "name": "create job_card",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:54.000000Z",
                        "updated_at": "2025-11-05T06:49:54.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1027
                        }
                    },
                    {
                        "id": 1028,
                        "name": "edit job_card",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:54.000000Z",
                        "updated_at": "2025-11-05T06:49:54.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1028
                        }
                    },
                    {
                        "id": 1029,
                        "name": "show job_card",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:54.000000Z",
                        "updated_at": "2025-11-05T06:49:54.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1029
                        }
                    },
                    {
                        "id": 1030,
                        "name": "delete job_card",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:54.000000Z",
                        "updated_at": "2025-11-05T06:49:54.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1030
                        }
                    },
                    {
                        "id": 1031,
                        "name": "manage jobcard dashboard",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:55.000000Z",
                        "updated_at": "2025-11-05T06:49:55.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1031
                        }
                    },
                    {
                        "id": 1032,
                        "name": "manage jobcard report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:55.000000Z",
                        "updated_at": "2025-11-05T06:49:55.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1032
                        }
                    },
                    {
                        "id": 1033,
                        "name": "manage jobcard_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:55.000000Z",
                        "updated_at": "2025-11-05T06:49:55.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1033
                        }
                    },
                    {
                        "id": 1034,
                        "name": "create jobcard_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:55.000000Z",
                        "updated_at": "2025-11-05T06:49:55.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1034
                        }
                    },
                    {
                        "id": 1035,
                        "name": "edit jobcard_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:55.000000Z",
                        "updated_at": "2025-11-05T06:49:55.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1035
                        }
                    },
                    {
                        "id": 1036,
                        "name": "show jobcard_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:56.000000Z",
                        "updated_at": "2025-11-05T06:49:56.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1036
                        }
                    },
                    {
                        "id": 1037,
                        "name": "delete jobcard_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:56.000000Z",
                        "updated_at": "2025-11-05T06:49:56.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1037
                        }
                    },
                    {
                        "id": 1038,
                        "name": "manage operator",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:56.000000Z",
                        "updated_at": "2025-11-05T06:49:56.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1038
                        }
                    },
                    {
                        "id": 1039,
                        "name": "create operator",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:56.000000Z",
                        "updated_at": "2025-11-05T06:49:56.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1039
                        }
                    },
                    {
                        "id": 1040,
                        "name": "edit operator",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:56.000000Z",
                        "updated_at": "2025-11-05T06:49:56.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1040
                        }
                    },
                    {
                        "id": 1041,
                        "name": "show operator",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:57.000000Z",
                        "updated_at": "2025-11-05T06:49:57.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1041
                        }
                    },
                    {
                        "id": 1042,
                        "name": "delete operator",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:57.000000Z",
                        "updated_at": "2025-11-05T06:49:57.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1042
                        }
                    },
                    {
                        "id": 1043,
                        "name": "manage general_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:57.000000Z",
                        "updated_at": "2025-11-05T06:49:57.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1043
                        }
                    },
                    {
                        "id": 1044,
                        "name": "create general_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:57.000000Z",
                        "updated_at": "2025-11-05T06:49:57.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1044
                        }
                    },
                    {
                        "id": 1045,
                        "name": "edit general_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:57.000000Z",
                        "updated_at": "2025-11-05T06:49:57.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1045
                        }
                    },
                    {
                        "id": 1046,
                        "name": "manage vehicle_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:58.000000Z",
                        "updated_at": "2025-11-05T06:49:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1046
                        }
                    },
                    {
                        "id": 1047,
                        "name": "create vehicle_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:58.000000Z",
                        "updated_at": "2025-11-05T06:49:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1047
                        }
                    },
                    {
                        "id": 1048,
                        "name": "edit vehicle_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:58.000000Z",
                        "updated_at": "2025-11-05T06:49:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1048
                        }
                    },
                    {
                        "id": 1049,
                        "name": "show vehicle_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:58.000000Z",
                        "updated_at": "2025-11-05T06:49:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1049
                        }
                    },
                    {
                        "id": 1050,
                        "name": "delete vehicle_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:58.000000Z",
                        "updated_at": "2025-11-05T06:49:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1050
                        }
                    },
                    {
                        "id": 1051,
                        "name": "manage routes_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:58.000000Z",
                        "updated_at": "2025-11-05T06:49:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1051
                        }
                    },
                    {
                        "id": 1052,
                        "name": "create routes_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:59.000000Z",
                        "updated_at": "2025-11-05T06:49:59.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1052
                        }
                    },
                    {
                        "id": 1053,
                        "name": "edit routes_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:59.000000Z",
                        "updated_at": "2025-11-05T06:49:59.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1053
                        }
                    },
                    {
                        "id": 1054,
                        "name": "show routes_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:59.000000Z",
                        "updated_at": "2025-11-05T06:49:59.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1054
                        }
                    },
                    {
                        "id": 1055,
                        "name": "delete routes_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:59.000000Z",
                        "updated_at": "2025-11-05T06:49:59.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1055
                        }
                    },
                    {
                        "id": 1056,
                        "name": "manage orders_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:49:59.000000Z",
                        "updated_at": "2025-11-05T06:49:59.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1056
                        }
                    },
                    {
                        "id": 1057,
                        "name": "create orders_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:00.000000Z",
                        "updated_at": "2025-11-05T06:50:00.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1057
                        }
                    },
                    {
                        "id": 1058,
                        "name": "edit orders_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:00.000000Z",
                        "updated_at": "2025-11-05T06:50:00.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1058
                        }
                    },
                    {
                        "id": 1059,
                        "name": "show orders_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:00.000000Z",
                        "updated_at": "2025-11-05T06:50:00.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1059
                        }
                    },
                    {
                        "id": 1060,
                        "name": "delete orders_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:00.000000Z",
                        "updated_at": "2025-11-05T06:50:00.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1060
                        }
                    },
                    {
                        "id": 1061,
                        "name": "manage vehicle_departure_schedule",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:00.000000Z",
                        "updated_at": "2025-11-05T06:50:00.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1061
                        }
                    },
                    {
                        "id": 1062,
                        "name": "create vehicle_departure_schedule",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:01.000000Z",
                        "updated_at": "2025-11-05T06:50:01.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1062
                        }
                    },
                    {
                        "id": 1063,
                        "name": "edit vehicle_departure_schedule",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:01.000000Z",
                        "updated_at": "2025-11-05T06:50:01.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1063
                        }
                    },
                    {
                        "id": 1064,
                        "name": "show vehicle_departure_schedule",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:01.000000Z",
                        "updated_at": "2025-11-05T06:50:01.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1064
                        }
                    },
                    {
                        "id": 1065,
                        "name": "delete vehicle_departure_schedule",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:01.000000Z",
                        "updated_at": "2025-11-05T06:50:01.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1065
                        }
                    },
                    {
                        "id": 1066,
                        "name": "manage trip_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:02.000000Z",
                        "updated_at": "2025-11-05T06:50:02.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1066
                        }
                    },
                    {
                        "id": 1067,
                        "name": "create trip_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:02.000000Z",
                        "updated_at": "2025-11-05T06:50:02.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1067
                        }
                    },
                    {
                        "id": 1068,
                        "name": "edit trip_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:02.000000Z",
                        "updated_at": "2025-11-05T06:50:02.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1068
                        }
                    },
                    {
                        "id": 1069,
                        "name": "show trip_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:02.000000Z",
                        "updated_at": "2025-11-05T06:50:02.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1069
                        }
                    },
                    {
                        "id": 1070,
                        "name": "delete trip_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:03.000000Z",
                        "updated_at": "2025-11-05T06:50:03.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1070
                        }
                    },
                    {
                        "id": 1071,
                        "name": "manage workshop_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:03.000000Z",
                        "updated_at": "2025-11-05T06:50:03.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1071
                        }
                    },
                    {
                        "id": 1072,
                        "name": "create workshop_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:03.000000Z",
                        "updated_at": "2025-11-05T06:50:03.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1072
                        }
                    },
                    {
                        "id": 1073,
                        "name": "edit workshop_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:03.000000Z",
                        "updated_at": "2025-11-05T06:50:03.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1073
                        }
                    },
                    {
                        "id": 1074,
                        "name": "show workshop_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:03.000000Z",
                        "updated_at": "2025-11-05T06:50:03.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1074
                        }
                    },
                    {
                        "id": 1075,
                        "name": "delete workshop_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:04.000000Z",
                        "updated_at": "2025-11-05T06:50:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1075
                        }
                    },
                    {
                        "id": 1076,
                        "name": "manage request_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:04.000000Z",
                        "updated_at": "2025-11-05T06:50:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1076
                        }
                    },
                    {
                        "id": 1077,
                        "name": "create request_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:04.000000Z",
                        "updated_at": "2025-11-05T06:50:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1077
                        }
                    },
                    {
                        "id": 1078,
                        "name": "edit request_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:04.000000Z",
                        "updated_at": "2025-11-05T06:50:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1078
                        }
                    },
                    {
                        "id": 1079,
                        "name": "show request_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:04.000000Z",
                        "updated_at": "2025-11-05T06:50:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1079
                        }
                    },
                    {
                        "id": 1080,
                        "name": "delete request_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:05.000000Z",
                        "updated_at": "2025-11-05T06:50:05.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1080
                        }
                    },
                    {
                        "id": 1081,
                        "name": "manage operator_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:05.000000Z",
                        "updated_at": "2025-11-05T06:50:05.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1081
                        }
                    },
                    {
                        "id": 1082,
                        "name": "create operator_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:05.000000Z",
                        "updated_at": "2025-11-05T06:50:05.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1082
                        }
                    },
                    {
                        "id": 1083,
                        "name": "edit operator_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:05.000000Z",
                        "updated_at": "2025-11-05T06:50:05.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1083
                        }
                    },
                    {
                        "id": 1084,
                        "name": "show operator_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:05.000000Z",
                        "updated_at": "2025-11-05T06:50:05.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1084
                        }
                    },
                    {
                        "id": 1085,
                        "name": "delete operator_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:06.000000Z",
                        "updated_at": "2025-11-05T06:50:06.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1085
                        }
                    },
                    {
                        "id": 1086,
                        "name": "manage tire",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:06.000000Z",
                        "updated_at": "2025-11-05T06:50:06.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1086
                        }
                    },
                    {
                        "id": 1087,
                        "name": "create tire",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:06.000000Z",
                        "updated_at": "2025-11-05T06:50:06.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1087
                        }
                    },
                    {
                        "id": 1088,
                        "name": "edit tire",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:06.000000Z",
                        "updated_at": "2025-11-05T06:50:06.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1088
                        }
                    },
                    {
                        "id": 1089,
                        "name": "show tire",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:06.000000Z",
                        "updated_at": "2025-11-05T06:50:06.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1089
                        }
                    },
                    {
                        "id": 1090,
                        "name": "delete tire",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:07.000000Z",
                        "updated_at": "2025-11-05T06:50:07.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1090
                        }
                    },
                    {
                        "id": 1091,
                        "name": "manage tire operation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:07.000000Z",
                        "updated_at": "2025-11-05T06:50:07.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1091
                        }
                    },
                    {
                        "id": 1092,
                        "name": "create tire operation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:07.000000Z",
                        "updated_at": "2025-11-05T06:50:07.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1092
                        }
                    },
                    {
                        "id": 1093,
                        "name": "edit tire operation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:07.000000Z",
                        "updated_at": "2025-11-05T06:50:07.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1093
                        }
                    },
                    {
                        "id": 1094,
                        "name": "show tire operation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:07.000000Z",
                        "updated_at": "2025-11-05T06:50:07.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1094
                        }
                    },
                    {
                        "id": 1095,
                        "name": "delete tire operation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:08.000000Z",
                        "updated_at": "2025-11-05T06:50:08.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1095
                        }
                    },
                    {
                        "id": 1096,
                        "name": "manage tire_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:08.000000Z",
                        "updated_at": "2025-11-05T06:50:08.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1096
                        }
                    },
                    {
                        "id": 1097,
                        "name": "create tire_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:08.000000Z",
                        "updated_at": "2025-11-05T06:50:08.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1097
                        }
                    },
                    {
                        "id": 1098,
                        "name": "edit tire_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:08.000000Z",
                        "updated_at": "2025-11-05T06:50:08.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1098
                        }
                    },
                    {
                        "id": 1099,
                        "name": "show tire_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:09.000000Z",
                        "updated_at": "2025-11-05T06:50:09.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1099
                        }
                    },
                    {
                        "id": 1100,
                        "name": "delete tire_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:09.000000Z",
                        "updated_at": "2025-11-05T06:50:09.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1100
                        }
                    },
                    {
                        "id": 1101,
                        "name": "manage workshop",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:09.000000Z",
                        "updated_at": "2025-11-05T06:50:09.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1101
                        }
                    },
                    {
                        "id": 1102,
                        "name": "create workshop",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:09.000000Z",
                        "updated_at": "2025-11-05T06:50:09.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1102
                        }
                    },
                    {
                        "id": 1103,
                        "name": "edit workshop",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:09.000000Z",
                        "updated_at": "2025-11-05T06:50:09.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1103
                        }
                    },
                    {
                        "id": 1104,
                        "name": "show workshop",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:10.000000Z",
                        "updated_at": "2025-11-05T06:50:10.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1104
                        }
                    },
                    {
                        "id": 1105,
                        "name": "delete workshop",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:10.000000Z",
                        "updated_at": "2025-11-05T06:50:10.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1105
                        }
                    },
                    {
                        "id": 1106,
                        "name": "manage report_builder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:10.000000Z",
                        "updated_at": "2025-11-05T06:50:10.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1106
                        }
                    },
                    {
                        "id": 1107,
                        "name": "create report_builder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:10.000000Z",
                        "updated_at": "2025-11-05T06:50:10.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1107
                        }
                    },
                    {
                        "id": 1108,
                        "name": "edit report_builder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:11.000000Z",
                        "updated_at": "2025-11-05T06:50:11.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1108
                        }
                    },
                    {
                        "id": 1109,
                        "name": "show report_builder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:11.000000Z",
                        "updated_at": "2025-11-05T06:50:11.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1109
                        }
                    },
                    {
                        "id": 1110,
                        "name": "delete report_builder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:11.000000Z",
                        "updated_at": "2025-11-05T06:50:11.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1110
                        }
                    },
                    {
                        "id": 1111,
                        "name": "manage sales_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:11.000000Z",
                        "updated_at": "2025-11-05T06:50:11.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1111
                        }
                    },
                    {
                        "id": 1112,
                        "name": "create sales_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:11.000000Z",
                        "updated_at": "2025-11-05T06:50:11.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1112
                        }
                    },
                    {
                        "id": 1113,
                        "name": "edit sales_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:12.000000Z",
                        "updated_at": "2025-11-05T06:50:12.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1113
                        }
                    },
                    {
                        "id": 1114,
                        "name": "show sales_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:12.000000Z",
                        "updated_at": "2025-11-05T06:50:12.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1114
                        }
                    },
                    {
                        "id": 1115,
                        "name": "delete sales_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:12.000000Z",
                        "updated_at": "2025-11-05T06:50:12.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1115
                        }
                    },
                    {
                        "id": 1116,
                        "name": "manage weighbridge settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:12.000000Z",
                        "updated_at": "2025-11-05T06:50:12.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1116
                        }
                    },
                    {
                        "id": 1117,
                        "name": "create weighbridge settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:12.000000Z",
                        "updated_at": "2025-11-05T06:50:12.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1117
                        }
                    },
                    {
                        "id": 1118,
                        "name": "edit weighbridge settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:13.000000Z",
                        "updated_at": "2025-11-05T06:50:13.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1118
                        }
                    },
                    {
                        "id": 1119,
                        "name": "show weighbridge settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:13.000000Z",
                        "updated_at": "2025-11-05T06:50:13.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1119
                        }
                    },
                    {
                        "id": 1120,
                        "name": "delete weighbridge settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:13.000000Z",
                        "updated_at": "2025-11-05T06:50:13.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1120
                        }
                    },
                    {
                        "id": 1121,
                        "name": "manage map_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:13.000000Z",
                        "updated_at": "2025-11-05T06:50:13.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1121
                        }
                    },
                    {
                        "id": 1122,
                        "name": "create map_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:13.000000Z",
                        "updated_at": "2025-11-05T06:50:13.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1122
                        }
                    },
                    {
                        "id": 1123,
                        "name": "edit map_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:14.000000Z",
                        "updated_at": "2025-11-05T06:50:14.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1123
                        }
                    },
                    {
                        "id": 1124,
                        "name": "show map_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:14.000000Z",
                        "updated_at": "2025-11-05T06:50:14.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1124
                        }
                    },
                    {
                        "id": 1125,
                        "name": "delete map_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:14.000000Z",
                        "updated_at": "2025-11-05T06:50:14.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1125
                        }
                    },
                    {
                        "id": 1126,
                        "name": "manage approval settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:14.000000Z",
                        "updated_at": "2025-11-05T06:50:14.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1126
                        }
                    },
                    {
                        "id": 1127,
                        "name": "create approval settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:14.000000Z",
                        "updated_at": "2025-11-05T06:50:14.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1127
                        }
                    },
                    {
                        "id": 1128,
                        "name": "edit approval settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:15.000000Z",
                        "updated_at": "2025-11-05T06:50:15.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1128
                        }
                    },
                    {
                        "id": 1129,
                        "name": "show approval settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:15.000000Z",
                        "updated_at": "2025-11-05T06:50:15.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1129
                        }
                    },
                    {
                        "id": 1130,
                        "name": "delete approval settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:15.000000Z",
                        "updated_at": "2025-11-05T06:50:15.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1130
                        }
                    },
                    {
                        "id": 1131,
                        "name": "manage purchase quotation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:15.000000Z",
                        "updated_at": "2025-11-05T06:50:15.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1131
                        }
                    },
                    {
                        "id": 1132,
                        "name": "create purchase quotation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:15.000000Z",
                        "updated_at": "2025-11-05T06:50:15.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1132
                        }
                    },
                    {
                        "id": 1133,
                        "name": "edit purchase quotation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:16.000000Z",
                        "updated_at": "2025-11-05T06:50:16.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1133
                        }
                    },
                    {
                        "id": 1134,
                        "name": "show purchase quotation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:16.000000Z",
                        "updated_at": "2025-11-05T06:50:16.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1134
                        }
                    },
                    {
                        "id": 1135,
                        "name": "delete purchase quotation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:16.000000Z",
                        "updated_at": "2025-11-05T06:50:16.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1135
                        }
                    },
                    {
                        "id": 1136,
                        "name": "send purchase quotation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:16.000000Z",
                        "updated_at": "2025-11-05T06:50:16.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1136
                        }
                    },
                    {
                        "id": 1137,
                        "name": "manage purchase order",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:16.000000Z",
                        "updated_at": "2025-11-05T06:50:16.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1137
                        }
                    },
                    {
                        "id": 1138,
                        "name": "create purchase order",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:17.000000Z",
                        "updated_at": "2025-11-05T06:50:17.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1138
                        }
                    },
                    {
                        "id": 1139,
                        "name": "edit purchase order",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:17.000000Z",
                        "updated_at": "2025-11-05T06:50:17.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1139
                        }
                    },
                    {
                        "id": 1140,
                        "name": "show purchase order",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:17.000000Z",
                        "updated_at": "2025-11-05T06:50:17.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1140
                        }
                    },
                    {
                        "id": 1141,
                        "name": "delete purchase order",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:17.000000Z",
                        "updated_at": "2025-11-05T06:50:17.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1141
                        }
                    },
                    {
                        "id": 1142,
                        "name": "send purchase order",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:18.000000Z",
                        "updated_at": "2025-11-05T06:50:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1142
                        }
                    },
                    {
                        "id": 1143,
                        "name": "manage purchase order status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:18.000000Z",
                        "updated_at": "2025-11-05T06:50:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1143
                        }
                    },
                    {
                        "id": 1144,
                        "name": "manage purchase order payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:18.000000Z",
                        "updated_at": "2025-11-05T06:50:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1144
                        }
                    },
                    {
                        "id": 1145,
                        "name": "create purchase order payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:18.000000Z",
                        "updated_at": "2025-11-05T06:50:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1145
                        }
                    },
                    {
                        "id": 1146,
                        "name": "edit purchase order payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:18.000000Z",
                        "updated_at": "2025-11-05T06:50:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1146
                        }
                    },
                    {
                        "id": 1147,
                        "name": "show purchase order payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:19.000000Z",
                        "updated_at": "2025-11-05T06:50:19.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1147
                        }
                    },
                    {
                        "id": 1148,
                        "name": "delete purchase order payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:19.000000Z",
                        "updated_at": "2025-11-05T06:50:19.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1148
                        }
                    },
                    {
                        "id": 1149,
                        "name": "manage purchases_list",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:19.000000Z",
                        "updated_at": "2025-11-05T06:50:19.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1149
                        }
                    },
                    {
                        "id": 1150,
                        "name": "create purchases_list",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:19.000000Z",
                        "updated_at": "2025-11-05T06:50:19.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1150
                        }
                    },
                    {
                        "id": 1151,
                        "name": "edit purchases_list",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:20.000000Z",
                        "updated_at": "2025-11-05T06:50:20.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1151
                        }
                    },
                    {
                        "id": 1152,
                        "name": "show purchases_list",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:20.000000Z",
                        "updated_at": "2025-11-05T06:50:20.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1152
                        }
                    },
                    {
                        "id": 1153,
                        "name": "delete purchases_list",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:20.000000Z",
                        "updated_at": "2025-11-05T06:50:20.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1153
                        }
                    },
                    {
                        "id": 1154,
                        "name": "manage purchase_request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:20.000000Z",
                        "updated_at": "2025-11-05T06:50:20.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1154
                        }
                    },
                    {
                        "id": 1155,
                        "name": "create purchase_request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:20.000000Z",
                        "updated_at": "2025-11-05T06:50:20.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1155
                        }
                    },
                    {
                        "id": 1156,
                        "name": "edit purchase_request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:21.000000Z",
                        "updated_at": "2025-11-05T06:50:21.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1156
                        }
                    },
                    {
                        "id": 1157,
                        "name": "show purchase_request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:21.000000Z",
                        "updated_at": "2025-11-05T06:50:21.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1157
                        }
                    },
                    {
                        "id": 1158,
                        "name": "delete purchase_request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:21.000000Z",
                        "updated_at": "2025-11-05T06:50:21.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1158
                        }
                    },
                    {
                        "id": 1159,
                        "name": "manage telematics",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:21.000000Z",
                        "updated_at": "2025-11-05T06:50:21.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1159
                        }
                    },
                    {
                        "id": 1160,
                        "name": "show telematics",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:22.000000Z",
                        "updated_at": "2025-11-05T06:50:22.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1160
                        }
                    },
                    {
                        "id": 1161,
                        "name": "manage vehicle_monitor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:22.000000Z",
                        "updated_at": "2025-11-05T06:50:22.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1161
                        }
                    },
                    {
                        "id": 1162,
                        "name": "create vehicle_monitor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:22.000000Z",
                        "updated_at": "2025-11-05T06:50:22.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1162
                        }
                    },
                    {
                        "id": 1163,
                        "name": "edit vehicle_monitor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:22.000000Z",
                        "updated_at": "2025-11-05T06:50:22.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1163
                        }
                    },
                    {
                        "id": 1164,
                        "name": "show vehicle_monitor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:23.000000Z",
                        "updated_at": "2025-11-05T06:50:23.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1164
                        }
                    },
                    {
                        "id": 1165,
                        "name": "delete vehicle_monitor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:23.000000Z",
                        "updated_at": "2025-11-05T06:50:23.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1165
                        }
                    },
                    {
                        "id": 1166,
                        "name": "manage purchases_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:23.000000Z",
                        "updated_at": "2025-11-05T06:50:23.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1166
                        }
                    },
                    {
                        "id": 1167,
                        "name": "create purchases_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:23.000000Z",
                        "updated_at": "2025-11-05T06:50:23.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1167
                        }
                    },
                    {
                        "id": 1168,
                        "name": "edit purchases_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:24.000000Z",
                        "updated_at": "2025-11-05T06:50:24.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1168
                        }
                    },
                    {
                        "id": 1169,
                        "name": "show purchases_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:24.000000Z",
                        "updated_at": "2025-11-05T06:50:24.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1169
                        }
                    },
                    {
                        "id": 1170,
                        "name": "delete purchases_settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:24.000000Z",
                        "updated_at": "2025-11-05T06:50:24.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1170
                        }
                    },
                    {
                        "id": 1171,
                        "name": "manage petty_cash balance sync",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:24.000000Z",
                        "updated_at": "2025-11-05T06:50:24.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1171
                        }
                    },
                    {
                        "id": 1172,
                        "name": "manage petty_cash",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:25.000000Z",
                        "updated_at": "2025-11-05T06:50:25.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1172
                        }
                    },
                    {
                        "id": 1173,
                        "name": "create petty_cash",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:25.000000Z",
                        "updated_at": "2025-11-05T06:50:25.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1173
                        }
                    },
                    {
                        "id": 1174,
                        "name": "edit petty_cash",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:25.000000Z",
                        "updated_at": "2025-11-05T06:50:25.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1174
                        }
                    },
                    {
                        "id": 1175,
                        "name": "show petty_cash",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:25.000000Z",
                        "updated_at": "2025-11-05T06:50:25.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1175
                        }
                    },
                    {
                        "id": 1176,
                        "name": "delete petty_cash",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:26.000000Z",
                        "updated_at": "2025-11-05T06:50:26.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1176
                        }
                    },
                    {
                        "id": 1177,
                        "name": "create lead meeting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:26.000000Z",
                        "updated_at": "2025-11-05T06:50:26.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1177
                        }
                    },
                    {
                        "id": 1178,
                        "name": "edit lead meeting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:26.000000Z",
                        "updated_at": "2025-11-05T06:50:26.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1178
                        }
                    },
                    {
                        "id": 1179,
                        "name": "delete lead meeting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:26.000000Z",
                        "updated_at": "2025-11-05T06:50:26.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1179
                        }
                    },
                    {
                        "id": 1180,
                        "name": "manage petty_cash_request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:27.000000Z",
                        "updated_at": "2025-11-05T06:50:27.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1180
                        }
                    },
                    {
                        "id": 1181,
                        "name": "create petty_cash_request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:27.000000Z",
                        "updated_at": "2025-11-05T06:50:27.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1181
                        }
                    },
                    {
                        "id": 1182,
                        "name": "edit petty_cash_request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:27.000000Z",
                        "updated_at": "2025-11-05T06:50:27.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1182
                        }
                    },
                    {
                        "id": 1183,
                        "name": "show petty_cash_request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:27.000000Z",
                        "updated_at": "2025-11-05T06:50:27.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1183
                        }
                    },
                    {
                        "id": 1184,
                        "name": "delete petty_cash_request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:28.000000Z",
                        "updated_at": "2025-11-05T06:50:28.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1184
                        }
                    },
                    {
                        "id": 1185,
                        "name": "approve petty_cash_request",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:28.000000Z",
                        "updated_at": "2025-11-05T06:50:28.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1185
                        }
                    },
                    {
                        "id": 1186,
                        "name": "manage account settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:28.000000Z",
                        "updated_at": "2025-11-05T06:50:28.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1186
                        }
                    },
                    {
                        "id": 1187,
                        "name": "create deal meeting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:28.000000Z",
                        "updated_at": "2025-11-05T06:50:28.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1187
                        }
                    },
                    {
                        "id": 1188,
                        "name": "edit deal meeting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:29.000000Z",
                        "updated_at": "2025-11-05T06:50:29.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1188
                        }
                    },
                    {
                        "id": 1189,
                        "name": "delete deal meeting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:29.000000Z",
                        "updated_at": "2025-11-05T06:50:29.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1189
                        }
                    },
                    {
                        "id": 1190,
                        "name": "manage crm settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:29.000000Z",
                        "updated_at": "2025-11-05T06:50:29.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1190
                        }
                    },
                    {
                        "id": 1191,
                        "name": "show support dashboard",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:29.000000Z",
                        "updated_at": "2025-11-05T06:50:29.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1191
                        }
                    },
                    {
                        "id": 1192,
                        "name": "show support report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:30.000000Z",
                        "updated_at": "2025-11-05T06:50:30.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1192
                        }
                    },
                    {
                        "id": 1193,
                        "name": "manage support tickets",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:30.000000Z",
                        "updated_at": "2025-11-05T06:50:30.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1193
                        }
                    },
                    {
                        "id": 1194,
                        "name": "show support tickets",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:30.000000Z",
                        "updated_at": "2025-11-05T06:50:30.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1194
                        }
                    },
                    {
                        "id": 1195,
                        "name": "create support tickets",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:30.000000Z",
                        "updated_at": "2025-11-05T06:50:30.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1195
                        }
                    },
                    {
                        "id": 1196,
                        "name": "edit support tickets",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:31.000000Z",
                        "updated_at": "2025-11-05T06:50:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1196
                        }
                    },
                    {
                        "id": 1197,
                        "name": "delete support tickets",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:31.000000Z",
                        "updated_at": "2025-11-05T06:50:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1197
                        }
                    },
                    {
                        "id": 1198,
                        "name": "manage support services",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:31.000000Z",
                        "updated_at": "2025-11-05T06:50:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1198
                        }
                    },
                    {
                        "id": 1199,
                        "name": "create support services",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:31.000000Z",
                        "updated_at": "2025-11-05T06:50:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1199
                        }
                    },
                    {
                        "id": 1200,
                        "name": "edit support services",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:32.000000Z",
                        "updated_at": "2025-11-05T06:50:32.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1200
                        }
                    },
                    {
                        "id": 1201,
                        "name": "show support services",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:32.000000Z",
                        "updated_at": "2025-11-05T06:50:32.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1201
                        }
                    },
                    {
                        "id": 1202,
                        "name": "delete support services",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:32.000000Z",
                        "updated_at": "2025-11-05T06:50:32.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1202
                        }
                    },
                    {
                        "id": 1203,
                        "name": "manage support supervisor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:32.000000Z",
                        "updated_at": "2025-11-05T06:50:32.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1203
                        }
                    },
                    {
                        "id": 1204,
                        "name": "create support supervisor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:33.000000Z",
                        "updated_at": "2025-11-05T06:50:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1204
                        }
                    },
                    {
                        "id": 1205,
                        "name": "edit support supervisor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:33.000000Z",
                        "updated_at": "2025-11-05T06:50:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1205
                        }
                    },
                    {
                        "id": 1206,
                        "name": "show support supervisor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:33.000000Z",
                        "updated_at": "2025-11-05T06:50:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1206
                        }
                    },
                    {
                        "id": 1207,
                        "name": "delete support supervisor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:33.000000Z",
                        "updated_at": "2025-11-05T06:50:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1207
                        }
                    },
                    {
                        "id": 1208,
                        "name": "manage location",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:34.000000Z",
                        "updated_at": "2025-11-05T06:50:34.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1208
                        }
                    },
                    {
                        "id": 1209,
                        "name": "create location",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:34.000000Z",
                        "updated_at": "2025-11-05T06:50:34.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1209
                        }
                    },
                    {
                        "id": 1210,
                        "name": "edit location",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:34.000000Z",
                        "updated_at": "2025-11-05T06:50:34.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1210
                        }
                    },
                    {
                        "id": 1211,
                        "name": "show location",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:34.000000Z",
                        "updated_at": "2025-11-05T06:50:34.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1211
                        }
                    },
                    {
                        "id": 1212,
                        "name": "delete location",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:34.000000Z",
                        "updated_at": "2025-11-05T06:50:34.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1212
                        }
                    },
                    {
                        "id": 1213,
                        "name": "manage support category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:35.000000Z",
                        "updated_at": "2025-11-05T06:50:35.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1213
                        }
                    },
                    {
                        "id": 1214,
                        "name": "create support category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:35.000000Z",
                        "updated_at": "2025-11-05T06:50:35.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1214
                        }
                    },
                    {
                        "id": 1215,
                        "name": "edit support category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:35.000000Z",
                        "updated_at": "2025-11-05T06:50:35.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1215
                        }
                    },
                    {
                        "id": 1216,
                        "name": "show support category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:35.000000Z",
                        "updated_at": "2025-11-05T06:50:35.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1216
                        }
                    },
                    {
                        "id": 1217,
                        "name": "delete support category",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:36.000000Z",
                        "updated_at": "2025-11-05T06:50:36.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1217
                        }
                    },
                    {
                        "id": 1218,
                        "name": "manage support status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:36.000000Z",
                        "updated_at": "2025-11-05T06:50:36.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1218
                        }
                    },
                    {
                        "id": 1219,
                        "name": "create support status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:36.000000Z",
                        "updated_at": "2025-11-05T06:50:36.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1219
                        }
                    },
                    {
                        "id": 1220,
                        "name": "edit support status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:36.000000Z",
                        "updated_at": "2025-11-05T06:50:36.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1220
                        }
                    },
                    {
                        "id": 1221,
                        "name": "show support status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:37.000000Z",
                        "updated_at": "2025-11-05T06:50:37.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1221
                        }
                    },
                    {
                        "id": 1222,
                        "name": "delete support status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:37.000000Z",
                        "updated_at": "2025-11-05T06:50:37.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1222
                        }
                    },
                    {
                        "id": 1223,
                        "name": "manage support priority",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:37.000000Z",
                        "updated_at": "2025-11-05T06:50:37.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1223
                        }
                    },
                    {
                        "id": 1224,
                        "name": "create support priority",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:37.000000Z",
                        "updated_at": "2025-11-05T06:50:37.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1224
                        }
                    },
                    {
                        "id": 1225,
                        "name": "edit support priority",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:38.000000Z",
                        "updated_at": "2025-11-05T06:50:38.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1225
                        }
                    },
                    {
                        "id": 1226,
                        "name": "show support priority",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:38.000000Z",
                        "updated_at": "2025-11-05T06:50:38.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1226
                        }
                    },
                    {
                        "id": 1227,
                        "name": "delete support priority",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:38.000000Z",
                        "updated_at": "2025-11-05T06:50:38.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1227
                        }
                    },
                    {
                        "id": 1228,
                        "name": "manage support department",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:38.000000Z",
                        "updated_at": "2025-11-05T06:50:38.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1228
                        }
                    },
                    {
                        "id": 1229,
                        "name": "create support department",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:39.000000Z",
                        "updated_at": "2025-11-05T06:50:39.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1229
                        }
                    },
                    {
                        "id": 1230,
                        "name": "edit support department",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:39.000000Z",
                        "updated_at": "2025-11-05T06:50:39.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1230
                        }
                    },
                    {
                        "id": 1231,
                        "name": "show support department",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:39.000000Z",
                        "updated_at": "2025-11-05T06:50:39.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1231
                        }
                    },
                    {
                        "id": 1232,
                        "name": "delete support department",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:39.000000Z",
                        "updated_at": "2025-11-05T06:50:39.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1232
                        }
                    },
                    {
                        "id": 1233,
                        "name": "manage support settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:40.000000Z",
                        "updated_at": "2025-11-05T06:50:40.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1233
                        }
                    },
                    {
                        "id": 1234,
                        "name": "show sms balance",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:40.000000Z",
                        "updated_at": "2025-11-05T06:50:40.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1234
                        }
                    },
                    {
                        "id": 1235,
                        "name": "manage bulk import export",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:40.000000Z",
                        "updated_at": "2025-11-05T06:50:40.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1235
                        }
                    },
                    {
                        "id": 1236,
                        "name": "show holiday",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:41.000000Z",
                        "updated_at": "2025-11-05T06:50:41.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1236
                        }
                    },
                    {
                        "id": 1237,
                        "name": "manage employment history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:41.000000Z",
                        "updated_at": "2025-11-05T06:50:41.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1237
                        }
                    },
                    {
                        "id": 1238,
                        "name": "create employment history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:41.000000Z",
                        "updated_at": "2025-11-05T06:50:41.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1238
                        }
                    },
                    {
                        "id": 1239,
                        "name": "edit employment history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:41.000000Z",
                        "updated_at": "2025-11-05T06:50:41.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1239
                        }
                    },
                    {
                        "id": 1240,
                        "name": "show employment history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:41.000000Z",
                        "updated_at": "2025-11-05T06:50:41.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1240
                        }
                    },
                    {
                        "id": 1241,
                        "name": "delete employment history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:42.000000Z",
                        "updated_at": "2025-11-05T06:50:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1241
                        }
                    },
                    {
                        "id": 1242,
                        "name": "manage id type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:42.000000Z",
                        "updated_at": "2025-11-05T06:50:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1242
                        }
                    },
                    {
                        "id": 1243,
                        "name": "create id type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:42.000000Z",
                        "updated_at": "2025-11-05T06:50:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1243
                        }
                    },
                    {
                        "id": 1244,
                        "name": "edit id type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:42.000000Z",
                        "updated_at": "2025-11-05T06:50:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1244
                        }
                    },
                    {
                        "id": 1245,
                        "name": "delete id type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:43.000000Z",
                        "updated_at": "2025-11-05T06:50:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1245
                        }
                    },
                    {
                        "id": 1246,
                        "name": "manage company debit account",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:43.000000Z",
                        "updated_at": "2025-11-05T06:50:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1246
                        }
                    },
                    {
                        "id": 1247,
                        "name": "create company debit account",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:43.000000Z",
                        "updated_at": "2025-11-05T06:50:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1247
                        }
                    },
                    {
                        "id": 1248,
                        "name": "edit company debit account",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:43.000000Z",
                        "updated_at": "2025-11-05T06:50:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1248
                        }
                    },
                    {
                        "id": 1249,
                        "name": "delete company debit account",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:44.000000Z",
                        "updated_at": "2025-11-05T06:50:44.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1249
                        }
                    },
                    {
                        "id": 1250,
                        "name": "manage service",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:44.000000Z",
                        "updated_at": "2025-11-05T06:50:44.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1250
                        }
                    },
                    {
                        "id": 1251,
                        "name": "create service",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:44.000000Z",
                        "updated_at": "2025-11-05T06:50:44.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1251
                        }
                    },
                    {
                        "id": 1252,
                        "name": "edit service",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:44.000000Z",
                        "updated_at": "2025-11-05T06:50:44.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1252
                        }
                    },
                    {
                        "id": 1253,
                        "name": "show service",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:45.000000Z",
                        "updated_at": "2025-11-05T06:50:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1253
                        }
                    },
                    {
                        "id": 1254,
                        "name": "delete service",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:45.000000Z",
                        "updated_at": "2025-11-05T06:50:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1254
                        }
                    },
                    {
                        "id": 1255,
                        "name": "manage service subscription",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:45.000000Z",
                        "updated_at": "2025-11-05T06:50:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1255
                        }
                    },
                    {
                        "id": 1256,
                        "name": "create service subscription",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:45.000000Z",
                        "updated_at": "2025-11-05T06:50:45.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1256
                        }
                    },
                    {
                        "id": 1257,
                        "name": "edit service subscription",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:46.000000Z",
                        "updated_at": "2025-11-05T06:50:46.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1257
                        }
                    },
                    {
                        "id": 1258,
                        "name": "show service subscription",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:46.000000Z",
                        "updated_at": "2025-11-05T06:50:46.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1258
                        }
                    },
                    {
                        "id": 1259,
                        "name": "delete service subscription",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:46.000000Z",
                        "updated_at": "2025-11-05T06:50:46.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1259
                        }
                    },
                    {
                        "id": 1260,
                        "name": "manage service history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:46.000000Z",
                        "updated_at": "2025-11-05T06:50:46.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1260
                        }
                    },
                    {
                        "id": 1261,
                        "name": "create service history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:47.000000Z",
                        "updated_at": "2025-11-05T06:50:47.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1261
                        }
                    },
                    {
                        "id": 1262,
                        "name": "edit service history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:47.000000Z",
                        "updated_at": "2025-11-05T06:50:47.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1262
                        }
                    },
                    {
                        "id": 1263,
                        "name": "show service history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:47.000000Z",
                        "updated_at": "2025-11-05T06:50:47.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1263
                        }
                    },
                    {
                        "id": 1264,
                        "name": "delete service history",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:47.000000Z",
                        "updated_at": "2025-11-05T06:50:47.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1264
                        }
                    },
                    {
                        "id": 1265,
                        "name": "manage service reminder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:48.000000Z",
                        "updated_at": "2025-11-05T06:50:48.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1265
                        }
                    },
                    {
                        "id": 1266,
                        "name": "create service reminder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:48.000000Z",
                        "updated_at": "2025-11-05T06:50:48.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1266
                        }
                    },
                    {
                        "id": 1267,
                        "name": "edit service reminder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:48.000000Z",
                        "updated_at": "2025-11-05T06:50:48.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1267
                        }
                    },
                    {
                        "id": 1268,
                        "name": "show service reminder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:48.000000Z",
                        "updated_at": "2025-11-05T06:50:48.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1268
                        }
                    },
                    {
                        "id": 1269,
                        "name": "delete service reminder",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:49.000000Z",
                        "updated_at": "2025-11-05T06:50:49.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1269
                        }
                    },
                    {
                        "id": 1270,
                        "name": "manage service task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:49.000000Z",
                        "updated_at": "2025-11-05T06:50:49.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1270
                        }
                    },
                    {
                        "id": 1271,
                        "name": "create service task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:49.000000Z",
                        "updated_at": "2025-11-05T06:50:49.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1271
                        }
                    },
                    {
                        "id": 1272,
                        "name": "edit service task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:49.000000Z",
                        "updated_at": "2025-11-05T06:50:49.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1272
                        }
                    },
                    {
                        "id": 1273,
                        "name": "show service task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:50.000000Z",
                        "updated_at": "2025-11-05T06:50:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1273
                        }
                    },
                    {
                        "id": 1274,
                        "name": "delete service task",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:50.000000Z",
                        "updated_at": "2025-11-05T06:50:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1274
                        }
                    },
                    {
                        "id": 1275,
                        "name": "manage billing plan",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:50.000000Z",
                        "updated_at": "2025-11-05T06:50:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1275
                        }
                    },
                    {
                        "id": 1276,
                        "name": "create billing plan",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:50.000000Z",
                        "updated_at": "2025-11-05T06:50:50.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1276
                        }
                    },
                    {
                        "id": 1277,
                        "name": "edit billing plan",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:51.000000Z",
                        "updated_at": "2025-11-05T06:50:51.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1277
                        }
                    },
                    {
                        "id": 1278,
                        "name": "show billing plan",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:51.000000Z",
                        "updated_at": "2025-11-05T06:50:51.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1278
                        }
                    },
                    {
                        "id": 1279,
                        "name": "delete billing plan",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:51.000000Z",
                        "updated_at": "2025-11-05T06:50:51.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1279
                        }
                    },
                    {
                        "id": 1280,
                        "name": "manage subscription status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:51.000000Z",
                        "updated_at": "2025-11-05T06:50:51.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1280
                        }
                    },
                    {
                        "id": 1281,
                        "name": "create subscription status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:52.000000Z",
                        "updated_at": "2025-11-05T06:50:52.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1281
                        }
                    },
                    {
                        "id": 1282,
                        "name": "edit subscription status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:52.000000Z",
                        "updated_at": "2025-11-05T06:50:52.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1282
                        }
                    },
                    {
                        "id": 1283,
                        "name": "show subscription status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:52.000000Z",
                        "updated_at": "2025-11-05T06:50:52.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1283
                        }
                    },
                    {
                        "id": 1284,
                        "name": "delete subscription status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:52.000000Z",
                        "updated_at": "2025-11-05T06:50:52.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1284
                        }
                    },
                    {
                        "id": 1285,
                        "name": "manage service settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:53.000000Z",
                        "updated_at": "2025-11-05T06:50:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1285
                        }
                    },
                    {
                        "id": 1286,
                        "name": "create service settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:53.000000Z",
                        "updated_at": "2025-11-05T06:50:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1286
                        }
                    },
                    {
                        "id": 1287,
                        "name": "edit service settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:53.000000Z",
                        "updated_at": "2025-11-05T06:50:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1287
                        }
                    },
                    {
                        "id": 1288,
                        "name": "show service settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:53.000000Z",
                        "updated_at": "2025-11-05T06:50:53.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1288
                        }
                    },
                    {
                        "id": 1289,
                        "name": "delete service settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:54.000000Z",
                        "updated_at": "2025-11-05T06:50:54.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1289
                        }
                    },
                    {
                        "id": 1290,
                        "name": "manage hrm notification setting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:54.000000Z",
                        "updated_at": "2025-11-05T06:50:54.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1290
                        }
                    },
                    {
                        "id": 1291,
                        "name": "manage loan notification setting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:54.000000Z",
                        "updated_at": "2025-11-05T06:50:54.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1291
                        }
                    },
                    {
                        "id": 1292,
                        "name": "manage sales notification setting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:54.000000Z",
                        "updated_at": "2025-11-05T06:50:54.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1292
                        }
                    },
                    {
                        "id": 1293,
                        "name": "manage inventory notification setting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:55.000000Z",
                        "updated_at": "2025-11-05T06:50:55.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1293
                        }
                    },
                    {
                        "id": 1294,
                        "name": "manage logistic notification setting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:55.000000Z",
                        "updated_at": "2025-11-05T06:50:55.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1294
                        }
                    },
                    {
                        "id": 1295,
                        "name": "manage account notification setting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:55.000000Z",
                        "updated_at": "2025-11-05T06:50:55.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1295
                        }
                    },
                    {
                        "id": 1296,
                        "name": "manage jobcard notification setting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:55.000000Z",
                        "updated_at": "2025-11-05T06:50:55.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1296
                        }
                    },
                    {
                        "id": 1297,
                        "name": "manage preclosure",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:56.000000Z",
                        "updated_at": "2025-11-05T06:50:56.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1297
                        }
                    },
                    {
                        "id": 1298,
                        "name": "show preclosure",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:56.000000Z",
                        "updated_at": "2025-11-05T06:50:56.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1298
                        }
                    },
                    {
                        "id": 1299,
                        "name": "create preclosure",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:56.000000Z",
                        "updated_at": "2025-11-05T06:50:56.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1299
                        }
                    },
                    {
                        "id": 1300,
                        "name": "edit preclosure",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:56.000000Z",
                        "updated_at": "2025-11-05T06:50:56.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1300
                        }
                    },
                    {
                        "id": 1301,
                        "name": "delete preclosure",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:57.000000Z",
                        "updated_at": "2025-11-05T06:50:57.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1301
                        }
                    },
                    {
                        "id": 1302,
                        "name": "manage payment term",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:57.000000Z",
                        "updated_at": "2025-11-05T06:50:57.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1302
                        }
                    },
                    {
                        "id": 1303,
                        "name": "show payment term",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:57.000000Z",
                        "updated_at": "2025-11-05T06:50:57.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1303
                        }
                    },
                    {
                        "id": 1304,
                        "name": "create payment term",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:58.000000Z",
                        "updated_at": "2025-11-05T06:50:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1304
                        }
                    },
                    {
                        "id": 1305,
                        "name": "edit payment term",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:58.000000Z",
                        "updated_at": "2025-11-05T06:50:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1305
                        }
                    },
                    {
                        "id": 1306,
                        "name": "delete payment term",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:58.000000Z",
                        "updated_at": "2025-11-05T06:50:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1306
                        }
                    },
                    {
                        "id": 1307,
                        "name": "manage payment method",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:58.000000Z",
                        "updated_at": "2025-11-05T06:50:58.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1307
                        }
                    },
                    {
                        "id": 1308,
                        "name": "show payment method",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:59.000000Z",
                        "updated_at": "2025-11-05T06:50:59.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1308
                        }
                    },
                    {
                        "id": 1309,
                        "name": "create payment method",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:59.000000Z",
                        "updated_at": "2025-11-05T06:50:59.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1309
                        }
                    },
                    {
                        "id": 1310,
                        "name": "edit payment method",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:59.000000Z",
                        "updated_at": "2025-11-05T06:50:59.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1310
                        }
                    },
                    {
                        "id": 1311,
                        "name": "delete payment method",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:50:59.000000Z",
                        "updated_at": "2025-11-05T06:50:59.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1311
                        }
                    },
                    {
                        "id": 1312,
                        "name": "manage loan disbursement",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:00.000000Z",
                        "updated_at": "2025-11-05T06:51:00.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1312
                        }
                    },
                    {
                        "id": 1313,
                        "name": "manage loan",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:00.000000Z",
                        "updated_at": "2025-11-05T06:51:00.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1313
                        }
                    },
                    {
                        "id": 1314,
                        "name": "show loan",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:00.000000Z",
                        "updated_at": "2025-11-05T06:51:00.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1314
                        }
                    },
                    {
                        "id": 1315,
                        "name": "manage office shift",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:00.000000Z",
                        "updated_at": "2025-11-05T06:51:00.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1315
                        }
                    },
                    {
                        "id": 1316,
                        "name": "show office shift",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:01.000000Z",
                        "updated_at": "2025-11-05T06:51:01.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1316
                        }
                    },
                    {
                        "id": 1317,
                        "name": "create office shift",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:01.000000Z",
                        "updated_at": "2025-11-05T06:51:01.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1317
                        }
                    },
                    {
                        "id": 1318,
                        "name": "edit office shift",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:01.000000Z",
                        "updated_at": "2025-11-05T06:51:01.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1318
                        }
                    },
                    {
                        "id": 1319,
                        "name": "delete office shift",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:01.000000Z",
                        "updated_at": "2025-11-05T06:51:01.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1319
                        }
                    },
                    {
                        "id": 1320,
                        "name": "manage loan penalty",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:02.000000Z",
                        "updated_at": "2025-11-05T06:51:02.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1320
                        }
                    },
                    {
                        "id": 1321,
                        "name": "show loan penalty",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:02.000000Z",
                        "updated_at": "2025-11-05T06:51:02.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1321
                        }
                    },
                    {
                        "id": 1322,
                        "name": "create loan penalty",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:02.000000Z",
                        "updated_at": "2025-11-05T06:51:02.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1322
                        }
                    },
                    {
                        "id": 1323,
                        "name": "edit loan penalty",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:02.000000Z",
                        "updated_at": "2025-11-05T06:51:02.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1323
                        }
                    },
                    {
                        "id": 1324,
                        "name": "delete loan penalty",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:03.000000Z",
                        "updated_at": "2025-11-05T06:51:03.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1324
                        }
                    },
                    {
                        "id": 1325,
                        "name": "edit loan active & paid off",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:03.000000Z",
                        "updated_at": "2025-11-05T06:51:03.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1325
                        }
                    },
                    {
                        "id": 1326,
                        "name": "delete loan active & paid off",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:03.000000Z",
                        "updated_at": "2025-11-05T06:51:03.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1326
                        }
                    },
                    {
                        "id": 1327,
                        "name": "manage loan type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:03.000000Z",
                        "updated_at": "2025-11-05T06:51:03.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1327
                        }
                    },
                    {
                        "id": 1328,
                        "name": "show loan type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:04.000000Z",
                        "updated_at": "2025-11-05T06:51:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1328
                        }
                    },
                    {
                        "id": 1329,
                        "name": "create loan type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:04.000000Z",
                        "updated_at": "2025-11-05T06:51:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1329
                        }
                    },
                    {
                        "id": 1330,
                        "name": "edit loan type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:04.000000Z",
                        "updated_at": "2025-11-05T06:51:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1330
                        }
                    },
                    {
                        "id": 1331,
                        "name": "delete loan type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:04.000000Z",
                        "updated_at": "2025-11-05T06:51:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1331
                        }
                    },
                    {
                        "id": 1332,
                        "name": "manage loan payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:04.000000Z",
                        "updated_at": "2025-11-05T06:51:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1332
                        }
                    },
                    {
                        "id": 1333,
                        "name": "show loan payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:05.000000Z",
                        "updated_at": "2025-11-05T06:51:05.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1333
                        }
                    },
                    {
                        "id": 1334,
                        "name": "create loan payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:05.000000Z",
                        "updated_at": "2025-11-05T06:51:05.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1334
                        }
                    },
                    {
                        "id": 1335,
                        "name": "edit loan payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:05.000000Z",
                        "updated_at": "2025-11-05T06:51:05.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1335
                        }
                    },
                    {
                        "id": 1336,
                        "name": "delete loan payment",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:05.000000Z",
                        "updated_at": "2025-11-05T06:51:05.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1336
                        }
                    },
                    {
                        "id": 1337,
                        "name": "manage loan status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:06.000000Z",
                        "updated_at": "2025-11-05T06:51:06.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1337
                        }
                    },
                    {
                        "id": 1338,
                        "name": "show loan status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:06.000000Z",
                        "updated_at": "2025-11-05T06:51:06.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1338
                        }
                    },
                    {
                        "id": 1339,
                        "name": "create loan status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:06.000000Z",
                        "updated_at": "2025-11-05T06:51:06.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1339
                        }
                    },
                    {
                        "id": 1340,
                        "name": "edit loan status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:06.000000Z",
                        "updated_at": "2025-11-05T06:51:06.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1340
                        }
                    },
                    {
                        "id": 1341,
                        "name": "delete loan status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:07.000000Z",
                        "updated_at": "2025-11-05T06:51:07.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1341
                        }
                    },
                    {
                        "id": 1342,
                        "name": "manage payment status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:07.000000Z",
                        "updated_at": "2025-11-05T06:51:07.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1342
                        }
                    },
                    {
                        "id": 1343,
                        "name": "show payment status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:07.000000Z",
                        "updated_at": "2025-11-05T06:51:07.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1343
                        }
                    },
                    {
                        "id": 1344,
                        "name": "create payment status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:07.000000Z",
                        "updated_at": "2025-11-05T06:51:07.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1344
                        }
                    },
                    {
                        "id": 1345,
                        "name": "edit payment status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:08.000000Z",
                        "updated_at": "2025-11-05T06:51:08.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1345
                        }
                    },
                    {
                        "id": 1346,
                        "name": "delete payment status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:08.000000Z",
                        "updated_at": "2025-11-05T06:51:08.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1346
                        }
                    },
                    {
                        "id": 1347,
                        "name": "manage loan refund",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:08.000000Z",
                        "updated_at": "2025-11-05T06:51:08.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1347
                        }
                    },
                    {
                        "id": 1348,
                        "name": "show loan refund",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:08.000000Z",
                        "updated_at": "2025-11-05T06:51:08.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1348
                        }
                    },
                    {
                        "id": 1349,
                        "name": "create loan refund",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:09.000000Z",
                        "updated_at": "2025-11-05T06:51:09.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1349
                        }
                    },
                    {
                        "id": 1350,
                        "name": "edit loan refund",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:09.000000Z",
                        "updated_at": "2025-11-05T06:51:09.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1350
                        }
                    },
                    {
                        "id": 1351,
                        "name": "delete loan refund",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:09.000000Z",
                        "updated_at": "2025-11-05T06:51:09.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1351
                        }
                    },
                    {
                        "id": 1352,
                        "name": "manage loan setting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:09.000000Z",
                        "updated_at": "2025-11-05T06:51:09.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1352
                        }
                    },
                    {
                        "id": 1353,
                        "name": "show loan setting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:10.000000Z",
                        "updated_at": "2025-11-05T06:51:10.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1353
                        }
                    },
                    {
                        "id": 1354,
                        "name": "create loan setting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:10.000000Z",
                        "updated_at": "2025-11-05T06:51:10.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1354
                        }
                    },
                    {
                        "id": 1355,
                        "name": "edit loan setting",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:10.000000Z",
                        "updated_at": "2025-11-05T06:51:10.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1355
                        }
                    },
                    {
                        "id": 1356,
                        "name": "manage loan document type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:10.000000Z",
                        "updated_at": "2025-11-05T06:51:10.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1356
                        }
                    },
                    {
                        "id": 1357,
                        "name": "delete loan document type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:11.000000Z",
                        "updated_at": "2025-11-05T06:51:11.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1357
                        }
                    },
                    {
                        "id": 1358,
                        "name": "create loan document type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:11.000000Z",
                        "updated_at": "2025-11-05T06:51:11.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1358
                        }
                    },
                    {
                        "id": 1359,
                        "name": "edit loan document type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:11.000000Z",
                        "updated_at": "2025-11-05T06:51:11.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1359
                        }
                    },
                    {
                        "id": 1360,
                        "name": "manage subsidy report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:12.000000Z",
                        "updated_at": "2025-11-05T06:51:12.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1360
                        }
                    },
                    {
                        "id": 1361,
                        "name": "show subsidy report",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:12.000000Z",
                        "updated_at": "2025-11-05T06:51:12.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1361
                        }
                    },
                    {
                        "id": 1362,
                        "name": "manage distributor order status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:12.000000Z",
                        "updated_at": "2025-11-05T06:51:12.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1362
                        }
                    },
                    {
                        "id": 1363,
                        "name": "show distributor order status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:12.000000Z",
                        "updated_at": "2025-11-05T06:51:12.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1363
                        }
                    },
                    {
                        "id": 1364,
                        "name": "create distributor order status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:13.000000Z",
                        "updated_at": "2025-11-05T06:51:13.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1364
                        }
                    },
                    {
                        "id": 1365,
                        "name": "delete distributor order status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:13.000000Z",
                        "updated_at": "2025-11-05T06:51:13.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1365
                        }
                    },
                    {
                        "id": 1366,
                        "name": "edit distributor order status",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:13.000000Z",
                        "updated_at": "2025-11-05T06:51:13.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1366
                        }
                    },
                    {
                        "id": 1367,
                        "name": "manage manufacturing",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:13.000000Z",
                        "updated_at": "2025-11-05T06:51:13.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1367
                        }
                    },
                    {
                        "id": 1368,
                        "name": "show manufacturing",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:14.000000Z",
                        "updated_at": "2025-11-05T06:51:14.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1368
                        }
                    },
                    {
                        "id": 1369,
                        "name": "create manufacturing",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:14.000000Z",
                        "updated_at": "2025-11-05T06:51:14.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1369
                        }
                    },
                    {
                        "id": 1370,
                        "name": "delete manufacturing",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:14.000000Z",
                        "updated_at": "2025-11-05T06:51:14.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1370
                        }
                    },
                    {
                        "id": 1371,
                        "name": "edit manufacturing",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:14.000000Z",
                        "updated_at": "2025-11-05T06:51:14.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1371
                        }
                    },
                    {
                        "id": 1372,
                        "name": "manage manufacturing settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:15.000000Z",
                        "updated_at": "2025-11-05T06:51:15.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1372
                        }
                    },
                    {
                        "id": 1373,
                        "name": "create manufacturing settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:15.000000Z",
                        "updated_at": "2025-11-05T06:51:15.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1373
                        }
                    },
                    {
                        "id": 1374,
                        "name": "edit manufacturing settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:15.000000Z",
                        "updated_at": "2025-11-05T06:51:15.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1374
                        }
                    },
                    {
                        "id": 1375,
                        "name": "delete manufacturing settings",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:15.000000Z",
                        "updated_at": "2025-11-05T06:51:15.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1375
                        }
                    },
                    {
                        "id": 1376,
                        "name": "manage manufacturing facility",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:16.000000Z",
                        "updated_at": "2025-11-05T06:51:16.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1376
                        }
                    },
                    {
                        "id": 1377,
                        "name": "create manufacturing facility",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:16.000000Z",
                        "updated_at": "2025-11-05T06:51:16.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1377
                        }
                    },
                    {
                        "id": 1378,
                        "name": "edit manufacturing facility",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:16.000000Z",
                        "updated_at": "2025-11-05T06:51:16.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1378
                        }
                    },
                    {
                        "id": 1379,
                        "name": "delete manufacturing facility",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:16.000000Z",
                        "updated_at": "2025-11-05T06:51:16.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1379
                        }
                    },
                    {
                        "id": 1380,
                        "name": "manage workstation type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:17.000000Z",
                        "updated_at": "2025-11-05T06:51:17.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1380
                        }
                    },
                    {
                        "id": 1381,
                        "name": "create workstation type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:17.000000Z",
                        "updated_at": "2025-11-05T06:51:17.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1381
                        }
                    },
                    {
                        "id": 1382,
                        "name": "edit workstation type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:17.000000Z",
                        "updated_at": "2025-11-05T06:51:17.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1382
                        }
                    },
                    {
                        "id": 1383,
                        "name": "delete workstation type",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:17.000000Z",
                        "updated_at": "2025-11-05T06:51:17.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1383
                        }
                    },
                    {
                        "id": 1384,
                        "name": "manage plant floor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:18.000000Z",
                        "updated_at": "2025-11-05T06:51:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1384
                        }
                    },
                    {
                        "id": 1385,
                        "name": "create plant floor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:18.000000Z",
                        "updated_at": "2025-11-05T06:51:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1385
                        }
                    },
                    {
                        "id": 1386,
                        "name": "edit plant floor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:18.000000Z",
                        "updated_at": "2025-11-05T06:51:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1386
                        }
                    },
                    {
                        "id": 1387,
                        "name": "delete plant floor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:19.000000Z",
                        "updated_at": "2025-11-05T06:51:19.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1387
                        }
                    },
                    {
                        "id": 1388,
                        "name": "show plant floor",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:19.000000Z",
                        "updated_at": "2025-11-05T06:51:19.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1388
                        }
                    },
                    {
                        "id": 1389,
                        "name": "manage work order",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:19.000000Z",
                        "updated_at": "2025-11-05T06:51:19.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1389
                        }
                    },
                    {
                        "id": 1390,
                        "name": "create work order",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:19.000000Z",
                        "updated_at": "2025-11-05T06:51:19.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1390
                        }
                    },
                    {
                        "id": 1391,
                        "name": "edit work order",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:20.000000Z",
                        "updated_at": "2025-11-05T06:51:20.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1391
                        }
                    },
                    {
                        "id": 1392,
                        "name": "delete work order",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:20.000000Z",
                        "updated_at": "2025-11-05T06:51:20.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1392
                        }
                    },
                    {
                        "id": 1393,
                        "name": "show work order",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:20.000000Z",
                        "updated_at": "2025-11-05T06:51:20.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1393
                        }
                    },
                    {
                        "id": 1394,
                        "name": "manage manufacturing lot",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:20.000000Z",
                        "updated_at": "2025-11-05T06:51:20.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1394
                        }
                    },
                    {
                        "id": 1395,
                        "name": "create manufacturing lot",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:21.000000Z",
                        "updated_at": "2025-11-05T06:51:21.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1395
                        }
                    },
                    {
                        "id": 1396,
                        "name": "edit manufacturing lot",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:21.000000Z",
                        "updated_at": "2025-11-05T06:51:21.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1396
                        }
                    },
                    {
                        "id": 1397,
                        "name": "delete manufacturing lot",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:21.000000Z",
                        "updated_at": "2025-11-05T06:51:21.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1397
                        }
                    },
                    {
                        "id": 1398,
                        "name": "manage bill of material",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:21.000000Z",
                        "updated_at": "2025-11-05T06:51:21.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1398
                        }
                    },
                    {
                        "id": 1399,
                        "name": "create bill of material",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:22.000000Z",
                        "updated_at": "2025-11-05T06:51:22.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1399
                        }
                    },
                    {
                        "id": 1400,
                        "name": "edit bill of material",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:22.000000Z",
                        "updated_at": "2025-11-05T06:51:22.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1400
                        }
                    },
                    {
                        "id": 1401,
                        "name": "delete bill of material",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:22.000000Z",
                        "updated_at": "2025-11-05T06:51:22.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1401
                        }
                    },
                    {
                        "id": 1402,
                        "name": "show bill of material",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:22.000000Z",
                        "updated_at": "2025-11-05T06:51:22.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1402
                        }
                    },
                    {
                        "id": 1403,
                        "name": "manage workstation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:23.000000Z",
                        "updated_at": "2025-11-05T06:51:23.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1403
                        }
                    },
                    {
                        "id": 1404,
                        "name": "create workstation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:23.000000Z",
                        "updated_at": "2025-11-05T06:51:23.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1404
                        }
                    },
                    {
                        "id": 1405,
                        "name": "edit workstation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:23.000000Z",
                        "updated_at": "2025-11-05T06:51:23.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1405
                        }
                    },
                    {
                        "id": 1406,
                        "name": "delete workstation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:23.000000Z",
                        "updated_at": "2025-11-05T06:51:23.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1406
                        }
                    },
                    {
                        "id": 1407,
                        "name": "show workstation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:24.000000Z",
                        "updated_at": "2025-11-05T06:51:24.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1407
                        }
                    },
                    {
                        "id": 1408,
                        "name": "manage operation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:24.000000Z",
                        "updated_at": "2025-11-05T06:51:24.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1408
                        }
                    },
                    {
                        "id": 1409,
                        "name": "create operation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:24.000000Z",
                        "updated_at": "2025-11-05T06:51:24.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1409
                        }
                    },
                    {
                        "id": 1410,
                        "name": "edit operation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:24.000000Z",
                        "updated_at": "2025-11-05T06:51:24.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1410
                        }
                    },
                    {
                        "id": 1411,
                        "name": "delete operation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:25.000000Z",
                        "updated_at": "2025-11-05T06:51:25.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1411
                        }
                    },
                    {
                        "id": 1412,
                        "name": "show operation",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:25.000000Z",
                        "updated_at": "2025-11-05T06:51:25.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1412
                        }
                    },
                    {
                        "id": 1413,
                        "name": "manage raw material",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:25.000000Z",
                        "updated_at": "2025-11-05T06:51:25.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1413
                        }
                    },
                    {
                        "id": 1414,
                        "name": "show raw material",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:25.000000Z",
                        "updated_at": "2025-11-05T06:51:25.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1414
                        }
                    },
                    {
                        "id": 1415,
                        "name": "create raw material",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:26.000000Z",
                        "updated_at": "2025-11-05T06:51:26.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1415
                        }
                    },
                    {
                        "id": 1416,
                        "name": "delete raw material",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:26.000000Z",
                        "updated_at": "2025-11-05T06:51:26.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1416
                        }
                    },
                    {
                        "id": 1417,
                        "name": "edit raw material",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:26.000000Z",
                        "updated_at": "2025-11-05T06:51:26.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1417
                        }
                    },
                    {
                        "id": 1418,
                        "name": "manage geofence",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:26.000000Z",
                        "updated_at": "2025-11-05T06:51:26.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1418
                        }
                    },
                    {
                        "id": 1419,
                        "name": "create geofence",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:27.000000Z",
                        "updated_at": "2025-11-05T06:51:27.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1419
                        }
                    },
                    {
                        "id": 1420,
                        "name": "edit geofence",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:27.000000Z",
                        "updated_at": "2025-11-05T06:51:27.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1420
                        }
                    },
                    {
                        "id": 1421,
                        "name": "show geofence",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:27.000000Z",
                        "updated_at": "2025-11-05T06:51:27.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1421
                        }
                    },
                    {
                        "id": 1422,
                        "name": "delete geofence",
                        "guard_name": "web",
                        "created_at": "2025-11-05T06:51:27.000000Z",
                        "updated_at": "2025-11-05T06:51:27.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1422
                        }
                    },
                    {
                        "id": 1425,
                        "name": "assign journey supervisor",
                        "guard_name": "web",
                        "created_at": "2025-11-07T13:46:15.000000Z",
                        "updated_at": "2025-11-07T13:46:15.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1425
                        }
                    },
                    {
                        "id": 1426,
                        "name": "manage all journeys",
                        "guard_name": "web",
                        "created_at": "2025-11-07T13:46:16.000000Z",
                        "updated_at": "2025-11-07T13:46:16.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1426
                        }
                    },
                    {
                        "id": 1427,
                        "name": "manage transport fee report",
                        "guard_name": "web",
                        "created_at": "2025-12-04T22:19:12.000000Z",
                        "updated_at": "2025-12-04T22:19:12.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1427
                        }
                    },
                    {
                        "id": 1428,
                        "name": "show transport fee report",
                        "guard_name": "web",
                        "created_at": "2025-12-04T22:19:12.000000Z",
                        "updated_at": "2025-12-04T22:19:12.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1428
                        }
                    },
                    {
                        "id": 1429,
                        "name": "show payment report",
                        "guard_name": "web",
                        "created_at": "2025-12-05T20:41:39.000000Z",
                        "updated_at": "2025-12-05T20:41:39.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1429
                        }
                    },
                    {
                        "id": 1430,
                        "name": "manage payment report",
                        "guard_name": "web",
                        "created_at": "2025-12-05T20:41:39.000000Z",
                        "updated_at": "2025-12-05T20:41:39.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1430
                        }
                    },
                    {
                        "id": 1431,
                        "name": "show pos dashboard",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1431
                        }
                    },
                    {
                        "id": 1432,
                        "name": "show crm dashboard",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1432
                        }
                    },
                    {
                        "id": 1433,
                        "name": "show hrm dashboard",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1433
                        }
                    },
                    {
                        "id": 1434,
                        "name": "copy invoice",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1434
                        }
                    },
                    {
                        "id": 1435,
                        "name": "show project dashboard",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1435
                        }
                    },
                    {
                        "id": 1436,
                        "name": "show matter dashboard",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1436
                        }
                    },
                    {
                        "id": 1437,
                        "name": "show account dashboard",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1437
                        }
                    },
                    {
                        "id": 1438,
                        "name": "manage user",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1438
                        }
                    },
                    {
                        "id": 1439,
                        "name": "create user",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1439
                        }
                    },
                    {
                        "id": 1440,
                        "name": "edit user",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1440
                        }
                    },
                    {
                        "id": 1441,
                        "name": "delete user",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1441
                        }
                    },
                    {
                        "id": 1444,
                        "name": "manage role",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1444
                        }
                    },
                    {
                        "id": 1445,
                        "name": "create role",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1445
                        }
                    },
                    {
                        "id": 1446,
                        "name": "edit role",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1446
                        }
                    },
                    {
                        "id": 1447,
                        "name": "delete role",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1447
                        }
                    },
                    {
                        "id": 1448,
                        "name": "manage permission",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1448
                        }
                    },
                    {
                        "id": 1449,
                        "name": "create permission",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1449
                        }
                    },
                    {
                        "id": 1450,
                        "name": "edit permission",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1450
                        }
                    },
                    {
                        "id": 1451,
                        "name": "delete permission",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1451
                        }
                    },
                    {
                        "id": 1453,
                        "name": "manage print settings",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1453
                        }
                    },
                    {
                        "id": 1454,
                        "name": "manage business settings",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1454
                        }
                    },
                    {
                        "id": 1456,
                        "name": "manage expense",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1456
                        }
                    },
                    {
                        "id": 1457,
                        "name": "create expense",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1457
                        }
                    },
                    {
                        "id": 1458,
                        "name": "edit expense",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1458
                        }
                    },
                    {
                        "id": 1459,
                        "name": "delete expense",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1459
                        }
                    },
                    {
                        "id": 1460,
                        "name": "manage invoice",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1460
                        }
                    },
                    {
                        "id": 1461,
                        "name": "create invoice",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1461
                        }
                    },
                    {
                        "id": 1462,
                        "name": "edit invoice",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1462
                        }
                    },
                    {
                        "id": 1463,
                        "name": "delete invoice",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1463
                        }
                    },
                    {
                        "id": 1464,
                        "name": "show invoice",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1464
                        }
                    },
                    {
                        "id": 1465,
                        "name": "create payment invoice",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1465
                        }
                    },
                    {
                        "id": 1466,
                        "name": "delete payment invoice",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1466
                        }
                    },
                    {
                        "id": 1467,
                        "name": "send invoice",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1467
                        }
                    },
                    {
                        "id": 1468,
                        "name": "delete invoice product",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1468
                        }
                    },
                    {
                        "id": 1469,
                        "name": "convert invoice",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1469
                        }
                    },
                    {
                        "id": 1470,
                        "name": "manage constant unit",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1470
                        }
                    },
                    {
                        "id": 1471,
                        "name": "create constant unit",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1471
                        }
                    },
                    {
                        "id": 1472,
                        "name": "edit constant unit",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1472
                        }
                    },
                    {
                        "id": 1473,
                        "name": "delete constant unit",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1473
                        }
                    },
                    {
                        "id": 1474,
                        "name": "manage constant tax",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1474
                        }
                    },
                    {
                        "id": 1475,
                        "name": "create constant tax",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1475
                        }
                    },
                    {
                        "id": 1476,
                        "name": "edit constant tax",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1476
                        }
                    },
                    {
                        "id": 1477,
                        "name": "delete constant tax",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1477
                        }
                    },
                    {
                        "id": 1478,
                        "name": "manage constant category",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1478
                        }
                    },
                    {
                        "id": 1479,
                        "name": "create constant category",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1479
                        }
                    },
                    {
                        "id": 1480,
                        "name": "edit constant category",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1480
                        }
                    },
                    {
                        "id": 1481,
                        "name": "delete constant category",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1481
                        }
                    },
                    {
                        "id": 1482,
                        "name": "manage items",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1482
                        }
                    },
                    {
                        "id": 1483,
                        "name": "create items",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1483
                        }
                    },
                    {
                        "id": 1484,
                        "name": "edit items",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1484
                        }
                    },
                    {
                        "id": 1485,
                        "name": "delete items",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1485
                        }
                    },
                    {
                        "id": 1486,
                        "name": "manage customer",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1486
                        }
                    },
                    {
                        "id": 1487,
                        "name": "create customer",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1487
                        }
                    },
                    {
                        "id": 1488,
                        "name": "edit customer",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1488
                        }
                    },
                    {
                        "id": 1489,
                        "name": "delete customer",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1489
                        }
                    },
                    {
                        "id": 1490,
                        "name": "show customer",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1490
                        }
                    },
                    {
                        "id": 1491,
                        "name": "manage bank account",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1491
                        }
                    },
                    {
                        "id": 1492,
                        "name": "create bank account",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1492
                        }
                    },
                    {
                        "id": 1493,
                        "name": "edit bank account",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1493
                        }
                    },
                    {
                        "id": 1494,
                        "name": "delete bank account",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1494
                        }
                    },
                    {
                        "id": 1495,
                        "name": "manage bank",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1495
                        }
                    },
                    {
                        "id": 1496,
                        "name": "create bank",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1496
                        }
                    },
                    {
                        "id": 1497,
                        "name": "edit bank",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1497
                        }
                    },
                    {
                        "id": 1498,
                        "name": "delete bank",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1498
                        }
                    },
                    {
                        "id": 1499,
                        "name": "manage bank transfer",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1499
                        }
                    },
                    {
                        "id": 1500,
                        "name": "create bank transfer",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1500
                        }
                    },
                    {
                        "id": 1501,
                        "name": "edit bank transfer",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1501
                        }
                    },
                    {
                        "id": 1502,
                        "name": "delete bank transfer",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1502
                        }
                    },
                    {
                        "id": 1503,
                        "name": "manage transaction",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1503
                        }
                    },
                    {
                        "id": 1504,
                        "name": "manage revenue",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1504
                        }
                    },
                    {
                        "id": 1505,
                        "name": "create revenue",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1505
                        }
                    },
                    {
                        "id": 1506,
                        "name": "edit revenue",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1506
                        }
                    },
                    {
                        "id": 1507,
                        "name": "delete revenue",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1507
                        }
                    },
                    {
                        "id": 1508,
                        "name": "manage bill",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1508
                        }
                    },
                    {
                        "id": 1509,
                        "name": "create bill",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1509
                        }
                    },
                    {
                        "id": 1510,
                        "name": "edit bill",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1510
                        }
                    },
                    {
                        "id": 1511,
                        "name": "delete bill",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1511
                        }
                    },
                    {
                        "id": 1512,
                        "name": "show bill",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1512
                        }
                    },
                    {
                        "id": 1513,
                        "name": "manage payment",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1513
                        }
                    },
                    {
                        "id": 1514,
                        "name": "create payment",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1514
                        }
                    },
                    {
                        "id": 1515,
                        "name": "edit payment",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1515
                        }
                    },
                    {
                        "id": 1516,
                        "name": "delete payment",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1516
                        }
                    },
                    {
                        "id": 1517,
                        "name": "delete bill product",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1517
                        }
                    },
                    {
                        "id": 1518,
                        "name": "send bill",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1518
                        }
                    },
                    {
                        "id": 1519,
                        "name": "create payment bill",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1519
                        }
                    },
                    {
                        "id": 1520,
                        "name": "delete payment bill",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1520
                        }
                    },
                    {
                        "id": 1521,
                        "name": "manage order",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1521
                        }
                    },
                    {
                        "id": 1522,
                        "name": "manage order status change",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1522
                        }
                    },
                    {
                        "id": 1523,
                        "name": "income report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1523
                        }
                    },
                    {
                        "id": 1524,
                        "name": "expense report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1524
                        }
                    },
                    {
                        "id": 1525,
                        "name": "income vs expense report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1525
                        }
                    },
                    {
                        "id": 1526,
                        "name": "invoice report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1526
                        }
                    },
                    {
                        "id": 1527,
                        "name": "bill report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1527
                        }
                    },
                    {
                        "id": 1528,
                        "name": "stock report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1528
                        }
                    },
                    {
                        "id": 1529,
                        "name": "tax report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1529
                        }
                    },
                    {
                        "id": 1530,
                        "name": "loss & profit report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1530
                        }
                    },
                    {
                        "id": 1534,
                        "name": "manage credit note",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1534
                        }
                    },
                    {
                        "id": 1535,
                        "name": "create credit note",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1535
                        }
                    },
                    {
                        "id": 1536,
                        "name": "edit credit note",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1536
                        }
                    },
                    {
                        "id": 1537,
                        "name": "delete credit note",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1537
                        }
                    },
                    {
                        "id": 1538,
                        "name": "manage debit note",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1538
                        }
                    },
                    {
                        "id": 1539,
                        "name": "create debit note",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1539
                        }
                    },
                    {
                        "id": 1540,
                        "name": "edit debit note",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1540
                        }
                    },
                    {
                        "id": 1541,
                        "name": "delete debit note",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1541
                        }
                    },
                    {
                        "id": 1542,
                        "name": "duplicate invoice",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1542
                        }
                    },
                    {
                        "id": 1543,
                        "name": "duplicate bill",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1543
                        }
                    },
                    {
                        "id": 1545,
                        "name": "manage goal",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1545
                        }
                    },
                    {
                        "id": 1546,
                        "name": "create goal",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1546
                        }
                    },
                    {
                        "id": 1547,
                        "name": "edit goal",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1547
                        }
                    },
                    {
                        "id": 1548,
                        "name": "delete goal",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1548
                        }
                    },
                    {
                        "id": 1549,
                        "name": "manage assets",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1549
                        }
                    },
                    {
                        "id": 1550,
                        "name": "create assets",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1550
                        }
                    },
                    {
                        "id": 1551,
                        "name": "edit assets",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1551
                        }
                    },
                    {
                        "id": 1552,
                        "name": "delete assets",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1552
                        }
                    },
                    {
                        "id": 1553,
                        "name": "statement report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1553
                        }
                    },
                    {
                        "id": 1554,
                        "name": "manage constant custom field",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1554
                        }
                    },
                    {
                        "id": 1555,
                        "name": "create constant custom field",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1555
                        }
                    },
                    {
                        "id": 1556,
                        "name": "edit constant custom field",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1556
                        }
                    },
                    {
                        "id": 1557,
                        "name": "delete constant custom field",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1557
                        }
                    },
                    {
                        "id": 1558,
                        "name": "manage chart of account",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1558
                        }
                    },
                    {
                        "id": 1559,
                        "name": "create chart of account",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1559
                        }
                    },
                    {
                        "id": 1560,
                        "name": "edit chart of account",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1560
                        }
                    },
                    {
                        "id": 1561,
                        "name": "delete chart of account",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1561
                        }
                    },
                    {
                        "id": 1562,
                        "name": "manage chart of account type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1562
                        }
                    },
                    {
                        "id": 1563,
                        "name": "create chart of account type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1563
                        }
                    },
                    {
                        "id": 1564,
                        "name": "edit chart of account type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1564
                        }
                    },
                    {
                        "id": 1565,
                        "name": "delete chart of account type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1565
                        }
                    },
                    {
                        "id": 1566,
                        "name": "manage chart of account sub type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1566
                        }
                    },
                    {
                        "id": 1567,
                        "name": "create chart of account sub type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1567
                        }
                    },
                    {
                        "id": 1568,
                        "name": "edit chart of account sub type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1568
                        }
                    },
                    {
                        "id": 1569,
                        "name": "delete chart of account sub type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1569
                        }
                    },
                    {
                        "id": 1570,
                        "name": "manage journal entry",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1570
                        }
                    },
                    {
                        "id": 1571,
                        "name": "create journal entry",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1571
                        }
                    },
                    {
                        "id": 1572,
                        "name": "edit journal entry",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1572
                        }
                    },
                    {
                        "id": 1573,
                        "name": "delete journal entry",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1573
                        }
                    },
                    {
                        "id": 1574,
                        "name": "show journal entry",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1574
                        }
                    },
                    {
                        "id": 1575,
                        "name": "balance sheet report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1575
                        }
                    },
                    {
                        "id": 1576,
                        "name": "ledger report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1576
                        }
                    },
                    {
                        "id": 1577,
                        "name": "trial balance report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1577
                        }
                    },
                    {
                        "id": 1578,
                        "name": "manage client",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1578
                        }
                    },
                    {
                        "id": 1579,
                        "name": "create client",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1579
                        }
                    },
                    {
                        "id": 1580,
                        "name": "edit client",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1580
                        }
                    },
                    {
                        "id": 1581,
                        "name": "delete client",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1581
                        }
                    },
                    {
                        "id": 1582,
                        "name": "manage lead",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1582
                        }
                    },
                    {
                        "id": 1583,
                        "name": "create lead",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1583
                        }
                    },
                    {
                        "id": 1584,
                        "name": "view lead",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1584
                        }
                    },
                    {
                        "id": 1585,
                        "name": "edit lead",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1585
                        }
                    },
                    {
                        "id": 1586,
                        "name": "delete lead",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1586
                        }
                    },
                    {
                        "id": 1587,
                        "name": "move lead",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1587
                        }
                    },
                    {
                        "id": 1588,
                        "name": "create lead call",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1588
                        }
                    },
                    {
                        "id": 1589,
                        "name": "edit lead call",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1589
                        }
                    },
                    {
                        "id": 1590,
                        "name": "delete lead call",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1590
                        }
                    },
                    {
                        "id": 1591,
                        "name": "create lead email",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1591
                        }
                    },
                    {
                        "id": 1592,
                        "name": "manage pipeline",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1592
                        }
                    },
                    {
                        "id": 1593,
                        "name": "create pipeline",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1593
                        }
                    },
                    {
                        "id": 1594,
                        "name": "edit pipeline",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1594
                        }
                    },
                    {
                        "id": 1595,
                        "name": "delete pipeline",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1595
                        }
                    },
                    {
                        "id": 1596,
                        "name": "manage lead stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1596
                        }
                    },
                    {
                        "id": 1597,
                        "name": "create lead stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1597
                        }
                    },
                    {
                        "id": 1598,
                        "name": "edit lead stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1598
                        }
                    },
                    {
                        "id": 1599,
                        "name": "delete lead stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1599
                        }
                    },
                    {
                        "id": 1600,
                        "name": "convert lead to deal",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1600
                        }
                    },
                    {
                        "id": 1601,
                        "name": "manage source",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1601
                        }
                    },
                    {
                        "id": 1602,
                        "name": "create source",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1602
                        }
                    },
                    {
                        "id": 1603,
                        "name": "edit source",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1603
                        }
                    },
                    {
                        "id": 1604,
                        "name": "delete source",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1604
                        }
                    },
                    {
                        "id": 1605,
                        "name": "manage label",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1605
                        }
                    },
                    {
                        "id": 1606,
                        "name": "create label",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1606
                        }
                    },
                    {
                        "id": 1607,
                        "name": "edit label",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1607
                        }
                    },
                    {
                        "id": 1608,
                        "name": "delete label",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1608
                        }
                    },
                    {
                        "id": 1609,
                        "name": "manage deal",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1609
                        }
                    },
                    {
                        "id": 1610,
                        "name": "create deal",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1610
                        }
                    },
                    {
                        "id": 1611,
                        "name": "view task",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1611
                        }
                    },
                    {
                        "id": 1612,
                        "name": "create task",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1612
                        }
                    },
                    {
                        "id": 1613,
                        "name": "edit task",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1613
                        }
                    },
                    {
                        "id": 1614,
                        "name": "delete task",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1614
                        }
                    },
                    {
                        "id": 1615,
                        "name": "edit deal",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1615
                        }
                    },
                    {
                        "id": 1616,
                        "name": "view deal",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1616
                        }
                    },
                    {
                        "id": 1617,
                        "name": "delete deal",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1617
                        }
                    },
                    {
                        "id": 1618,
                        "name": "move deal",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1618
                        }
                    },
                    {
                        "id": 1619,
                        "name": "create deal call",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1619
                        }
                    },
                    {
                        "id": 1620,
                        "name": "edit deal call",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1620
                        }
                    },
                    {
                        "id": 1621,
                        "name": "delete deal call",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1621
                        }
                    },
                    {
                        "id": 1622,
                        "name": "create deal email",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1622
                        }
                    },
                    {
                        "id": 1623,
                        "name": "manage stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1623
                        }
                    },
                    {
                        "id": 1624,
                        "name": "create stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1624
                        }
                    },
                    {
                        "id": 1625,
                        "name": "edit stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1625
                        }
                    },
                    {
                        "id": 1626,
                        "name": "delete stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1626
                        }
                    },
                    {
                        "id": 1627,
                        "name": "manage employee",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1627
                        }
                    },
                    {
                        "id": 1628,
                        "name": "create employee",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1628
                        }
                    },
                    {
                        "id": 1629,
                        "name": "view employee",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1629
                        }
                    },
                    {
                        "id": 1630,
                        "name": "edit employee",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1630
                        }
                    },
                    {
                        "id": 1631,
                        "name": "delete employee",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1631
                        }
                    },
                    {
                        "id": 1632,
                        "name": "manage employee profile",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1632
                        }
                    },
                    {
                        "id": 1633,
                        "name": "show employee profile",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1633
                        }
                    },
                    {
                        "id": 1634,
                        "name": "manage department",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1634
                        }
                    },
                    {
                        "id": 1635,
                        "name": "create department",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1635
                        }
                    },
                    {
                        "id": 1636,
                        "name": "view department",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1636
                        }
                    },
                    {
                        "id": 1637,
                        "name": "edit department",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1637
                        }
                    },
                    {
                        "id": 1638,
                        "name": "delete department",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1638
                        }
                    },
                    {
                        "id": 1639,
                        "name": "manage designation",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1639
                        }
                    },
                    {
                        "id": 1640,
                        "name": "create designation",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1640
                        }
                    },
                    {
                        "id": 1641,
                        "name": "view designation",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1641
                        }
                    },
                    {
                        "id": 1642,
                        "name": "edit designation",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1642
                        }
                    },
                    {
                        "id": 1643,
                        "name": "delete designation",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1643
                        }
                    },
                    {
                        "id": 1644,
                        "name": "manage branch",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1644
                        }
                    },
                    {
                        "id": 1645,
                        "name": "create branch",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1645
                        }
                    },
                    {
                        "id": 1646,
                        "name": "edit branch",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1646
                        }
                    },
                    {
                        "id": 1647,
                        "name": "delete branch",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1647
                        }
                    },
                    {
                        "id": 1648,
                        "name": "manage document type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1648
                        }
                    },
                    {
                        "id": 1649,
                        "name": "create document type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1649
                        }
                    },
                    {
                        "id": 1650,
                        "name": "edit document type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1650
                        }
                    },
                    {
                        "id": 1651,
                        "name": "delete document type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1651
                        }
                    },
                    {
                        "id": 1652,
                        "name": "manage document",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1652
                        }
                    },
                    {
                        "id": 1653,
                        "name": "create document",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1653
                        }
                    },
                    {
                        "id": 1654,
                        "name": "edit document",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1654
                        }
                    },
                    {
                        "id": 1655,
                        "name": "delete document",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1655
                        }
                    },
                    {
                        "id": 1656,
                        "name": "manage payslip type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1656
                        }
                    },
                    {
                        "id": 1657,
                        "name": "create payslip type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1657
                        }
                    },
                    {
                        "id": 1658,
                        "name": "edit payslip type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1658
                        }
                    },
                    {
                        "id": 1659,
                        "name": "delete payslip type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1659
                        }
                    },
                    {
                        "id": 1660,
                        "name": "create allowance",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1660
                        }
                    },
                    {
                        "id": 1661,
                        "name": "edit allowance",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1661
                        }
                    },
                    {
                        "id": 1662,
                        "name": "delete allowance",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1662
                        }
                    },
                    {
                        "id": 1663,
                        "name": "create commission",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1663
                        }
                    },
                    {
                        "id": 1664,
                        "name": "edit commission",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1664
                        }
                    },
                    {
                        "id": 1665,
                        "name": "delete commission",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1665
                        }
                    },
                    {
                        "id": 1666,
                        "name": "manage allowance option",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1666
                        }
                    },
                    {
                        "id": 1667,
                        "name": "create allowance option",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1667
                        }
                    },
                    {
                        "id": 1668,
                        "name": "edit allowance option",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1668
                        }
                    },
                    {
                        "id": 1669,
                        "name": "delete allowance option",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1669
                        }
                    },
                    {
                        "id": 1670,
                        "name": "manage loan option",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1670
                        }
                    },
                    {
                        "id": 1671,
                        "name": "create loan option",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1671
                        }
                    },
                    {
                        "id": 1672,
                        "name": "edit loan option",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1672
                        }
                    },
                    {
                        "id": 1673,
                        "name": "delete loan option",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1673
                        }
                    },
                    {
                        "id": 1674,
                        "name": "manage deduction option",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1674
                        }
                    },
                    {
                        "id": 1675,
                        "name": "create deduction option",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1675
                        }
                    },
                    {
                        "id": 1676,
                        "name": "edit deduction option",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1676
                        }
                    },
                    {
                        "id": 1677,
                        "name": "delete deduction option",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1677
                        }
                    },
                    {
                        "id": 1678,
                        "name": "create loan",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1678
                        }
                    },
                    {
                        "id": 1679,
                        "name": "edit loan",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1679
                        }
                    },
                    {
                        "id": 1680,
                        "name": "delete loan",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1680
                        }
                    },
                    {
                        "id": 1681,
                        "name": "create other deduction",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1681
                        }
                    },
                    {
                        "id": 1682,
                        "name": "edit other deduction",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1682
                        }
                    },
                    {
                        "id": 1683,
                        "name": "delete other deduction",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1683
                        }
                    },
                    {
                        "id": 1684,
                        "name": "create other payment",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1684
                        }
                    },
                    {
                        "id": 1685,
                        "name": "edit other payment",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1685
                        }
                    },
                    {
                        "id": 1686,
                        "name": "delete other payment",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1686
                        }
                    },
                    {
                        "id": 1687,
                        "name": "create overtime",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1687
                        }
                    },
                    {
                        "id": 1688,
                        "name": "edit overtime",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1688
                        }
                    },
                    {
                        "id": 1689,
                        "name": "delete overtime",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1689
                        }
                    },
                    {
                        "id": 1690,
                        "name": "manage set salary",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1690
                        }
                    },
                    {
                        "id": 1691,
                        "name": "edit set salary",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1691
                        }
                    },
                    {
                        "id": 1692,
                        "name": "manage pay slip",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1692
                        }
                    },
                    {
                        "id": 1693,
                        "name": "create set salary",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1693
                        }
                    },
                    {
                        "id": 1694,
                        "name": "create pay slip",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1694
                        }
                    },
                    {
                        "id": 1695,
                        "name": "manage company policy",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1695
                        }
                    },
                    {
                        "id": 1696,
                        "name": "create company policy",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1696
                        }
                    },
                    {
                        "id": 1697,
                        "name": "edit company policy",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1697
                        }
                    },
                    {
                        "id": 1698,
                        "name": "manage appraisal",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1698
                        }
                    },
                    {
                        "id": 1699,
                        "name": "create appraisal",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1699
                        }
                    },
                    {
                        "id": 1700,
                        "name": "edit appraisal",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1700
                        }
                    },
                    {
                        "id": 1701,
                        "name": "show appraisal",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1701
                        }
                    },
                    {
                        "id": 1702,
                        "name": "delete appraisal",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1702
                        }
                    },
                    {
                        "id": 1703,
                        "name": "manage goal tracking",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1703
                        }
                    },
                    {
                        "id": 1704,
                        "name": "create goal tracking",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1704
                        }
                    },
                    {
                        "id": 1705,
                        "name": "edit goal tracking",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1705
                        }
                    },
                    {
                        "id": 1706,
                        "name": "delete goal tracking",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1706
                        }
                    },
                    {
                        "id": 1707,
                        "name": "manage goal type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1707
                        }
                    },
                    {
                        "id": 1708,
                        "name": "create goal type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1708
                        }
                    },
                    {
                        "id": 1709,
                        "name": "edit goal type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1709
                        }
                    },
                    {
                        "id": 1710,
                        "name": "delete goal type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1710
                        }
                    },
                    {
                        "id": 1711,
                        "name": "manage indicator",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1711
                        }
                    },
                    {
                        "id": 1712,
                        "name": "create indicator",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1712
                        }
                    },
                    {
                        "id": 1713,
                        "name": "edit indicator",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1713
                        }
                    },
                    {
                        "id": 1714,
                        "name": "show indicator",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1714
                        }
                    },
                    {
                        "id": 1715,
                        "name": "delete indicator",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1715
                        }
                    },
                    {
                        "id": 1716,
                        "name": "manage training",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1716
                        }
                    },
                    {
                        "id": 1717,
                        "name": "create training",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1717
                        }
                    },
                    {
                        "id": 1718,
                        "name": "edit training",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1718
                        }
                    },
                    {
                        "id": 1719,
                        "name": "delete training",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1719
                        }
                    },
                    {
                        "id": 1720,
                        "name": "show training",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1720
                        }
                    },
                    {
                        "id": 1721,
                        "name": "manage trainer",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1721
                        }
                    },
                    {
                        "id": 1722,
                        "name": "create trainer",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1722
                        }
                    },
                    {
                        "id": 1723,
                        "name": "edit trainer",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1723
                        }
                    },
                    {
                        "id": 1724,
                        "name": "delete trainer",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1724
                        }
                    },
                    {
                        "id": 1725,
                        "name": "manage training type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1725
                        }
                    },
                    {
                        "id": 1726,
                        "name": "create training type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1726
                        }
                    },
                    {
                        "id": 1727,
                        "name": "edit training type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1727
                        }
                    },
                    {
                        "id": 1728,
                        "name": "delete training type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1728
                        }
                    },
                    {
                        "id": 1729,
                        "name": "manage award",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1729
                        }
                    },
                    {
                        "id": 1730,
                        "name": "create award",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1730
                        }
                    },
                    {
                        "id": 1731,
                        "name": "edit award",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1731
                        }
                    },
                    {
                        "id": 1732,
                        "name": "delete award",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1732
                        }
                    },
                    {
                        "id": 1733,
                        "name": "manage award type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1733
                        }
                    },
                    {
                        "id": 1734,
                        "name": "create award type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1734
                        }
                    },
                    {
                        "id": 1735,
                        "name": "edit award type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1735
                        }
                    },
                    {
                        "id": 1736,
                        "name": "delete award type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1736
                        }
                    },
                    {
                        "id": 1737,
                        "name": "manage resignation",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1737
                        }
                    },
                    {
                        "id": 1738,
                        "name": "create resignation",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1738
                        }
                    },
                    {
                        "id": 1739,
                        "name": "edit resignation",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1739
                        }
                    },
                    {
                        "id": 1740,
                        "name": "delete resignation",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1740
                        }
                    },
                    {
                        "id": 1741,
                        "name": "manage travel",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1741
                        }
                    },
                    {
                        "id": 1742,
                        "name": "create travel",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1742
                        }
                    },
                    {
                        "id": 1743,
                        "name": "edit travel",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1743
                        }
                    },
                    {
                        "id": 1744,
                        "name": "delete travel",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1744
                        }
                    },
                    {
                        "id": 1745,
                        "name": "manage promotion",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1745
                        }
                    },
                    {
                        "id": 1746,
                        "name": "create promotion",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1746
                        }
                    },
                    {
                        "id": 1747,
                        "name": "edit promotion",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1747
                        }
                    },
                    {
                        "id": 1748,
                        "name": "delete promotion",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1748
                        }
                    },
                    {
                        "id": 1749,
                        "name": "manage complaint",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1749
                        }
                    },
                    {
                        "id": 1750,
                        "name": "create complaint",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1750
                        }
                    },
                    {
                        "id": 1751,
                        "name": "edit complaint",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1751
                        }
                    },
                    {
                        "id": 1752,
                        "name": "delete complaint",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1752
                        }
                    },
                    {
                        "id": 1753,
                        "name": "manage warning",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1753
                        }
                    },
                    {
                        "id": 1754,
                        "name": "create warning",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1754
                        }
                    },
                    {
                        "id": 1755,
                        "name": "edit warning",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1755
                        }
                    },
                    {
                        "id": 1756,
                        "name": "delete warning",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1756
                        }
                    },
                    {
                        "id": 1757,
                        "name": "manage termination",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1757
                        }
                    },
                    {
                        "id": 1758,
                        "name": "create termination",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1758
                        }
                    },
                    {
                        "id": 1759,
                        "name": "edit termination",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1759
                        }
                    },
                    {
                        "id": 1760,
                        "name": "delete termination",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1760
                        }
                    },
                    {
                        "id": 1761,
                        "name": "manage termination type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1761
                        }
                    },
                    {
                        "id": 1762,
                        "name": "create termination type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1762
                        }
                    },
                    {
                        "id": 1763,
                        "name": "edit termination type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1763
                        }
                    },
                    {
                        "id": 1764,
                        "name": "delete termination type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1764
                        }
                    },
                    {
                        "id": 1765,
                        "name": "manage job application",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1765
                        }
                    },
                    {
                        "id": 1766,
                        "name": "create job application",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1766
                        }
                    },
                    {
                        "id": 1767,
                        "name": "show job application",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1767
                        }
                    },
                    {
                        "id": 1768,
                        "name": "delete job application",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1768
                        }
                    },
                    {
                        "id": 1769,
                        "name": "move job application",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1769
                        }
                    },
                    {
                        "id": 1770,
                        "name": "add job application skill",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1770
                        }
                    },
                    {
                        "id": 1771,
                        "name": "add job application note",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1771
                        }
                    },
                    {
                        "id": 1772,
                        "name": "delete job application note",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1772
                        }
                    },
                    {
                        "id": 1773,
                        "name": "manage job onBoard",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1773
                        }
                    },
                    {
                        "id": 1774,
                        "name": "manage job category",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1774
                        }
                    },
                    {
                        "id": 1775,
                        "name": "create job category",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1775
                        }
                    },
                    {
                        "id": 1776,
                        "name": "edit job category",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1776
                        }
                    },
                    {
                        "id": 1777,
                        "name": "delete job category",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1777
                        }
                    },
                    {
                        "id": 1778,
                        "name": "manage job",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1778
                        }
                    },
                    {
                        "id": 1779,
                        "name": "create job",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1779
                        }
                    },
                    {
                        "id": 1780,
                        "name": "edit job",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1780
                        }
                    },
                    {
                        "id": 1781,
                        "name": "show job",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1781
                        }
                    },
                    {
                        "id": 1782,
                        "name": "delete job",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1782
                        }
                    },
                    {
                        "id": 1783,
                        "name": "manage job stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1783
                        }
                    },
                    {
                        "id": 1784,
                        "name": "create job stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1784
                        }
                    },
                    {
                        "id": 1785,
                        "name": "edit job stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1785
                        }
                    },
                    {
                        "id": 1786,
                        "name": "delete job stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1786
                        }
                    },
                    {
                        "id": 1787,
                        "name": "Manage Competencies",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1787
                        }
                    },
                    {
                        "id": 1788,
                        "name": "Create Competencies",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1788
                        }
                    },
                    {
                        "id": 1789,
                        "name": "Edit Competencies",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1789
                        }
                    },
                    {
                        "id": 1790,
                        "name": "Delete Competencies",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1790
                        }
                    },
                    {
                        "id": 1791,
                        "name": "manage custom question",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1791
                        }
                    },
                    {
                        "id": 1792,
                        "name": "create custom question",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1792
                        }
                    },
                    {
                        "id": 1793,
                        "name": "edit custom question",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1793
                        }
                    },
                    {
                        "id": 1794,
                        "name": "delete custom question",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1794
                        }
                    },
                    {
                        "id": 1795,
                        "name": "create interview schedule",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1795
                        }
                    },
                    {
                        "id": 1796,
                        "name": "edit interview schedule",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1796
                        }
                    },
                    {
                        "id": 1797,
                        "name": "delete interview schedule",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1797
                        }
                    },
                    {
                        "id": 1798,
                        "name": "show interview schedule",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1798
                        }
                    },
                    {
                        "id": 1799,
                        "name": "create estimation",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1799
                        }
                    },
                    {
                        "id": 1800,
                        "name": "view estimation",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1800
                        }
                    },
                    {
                        "id": 1801,
                        "name": "edit estimation",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1801
                        }
                    },
                    {
                        "id": 1802,
                        "name": "delete estimation",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1802
                        }
                    },
                    {
                        "id": 1803,
                        "name": "edit holiday",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1803
                        }
                    },
                    {
                        "id": 1804,
                        "name": "create holiday",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1804
                        }
                    },
                    {
                        "id": 1805,
                        "name": "delete holiday",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1805
                        }
                    },
                    {
                        "id": 1806,
                        "name": "manage holiday",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1806
                        }
                    },
                    {
                        "id": 1807,
                        "name": "show career",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1807
                        }
                    },
                    {
                        "id": 1808,
                        "name": "manage meeting",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1808
                        }
                    },
                    {
                        "id": 1809,
                        "name": "create meeting",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1809
                        }
                    },
                    {
                        "id": 1810,
                        "name": "edit meeting",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1810
                        }
                    },
                    {
                        "id": 1811,
                        "name": "delete meeting",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1811
                        }
                    },
                    {
                        "id": 1812,
                        "name": "manage event",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1812
                        }
                    },
                    {
                        "id": 1813,
                        "name": "create event",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1813
                        }
                    },
                    {
                        "id": 1814,
                        "name": "edit event",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1814
                        }
                    },
                    {
                        "id": 1815,
                        "name": "delete event",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1815
                        }
                    },
                    {
                        "id": 1816,
                        "name": "manage transfer",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1816
                        }
                    },
                    {
                        "id": 1817,
                        "name": "create transfer",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1817
                        }
                    },
                    {
                        "id": 1818,
                        "name": "edit transfer",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1818
                        }
                    },
                    {
                        "id": 1819,
                        "name": "delete transfer",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1819
                        }
                    },
                    {
                        "id": 1820,
                        "name": "manage announcement",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1820
                        }
                    },
                    {
                        "id": 1821,
                        "name": "create announcement",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1821
                        }
                    },
                    {
                        "id": 1822,
                        "name": "edit announcement",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1822
                        }
                    },
                    {
                        "id": 1823,
                        "name": "delete announcement",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1823
                        }
                    },
                    {
                        "id": 1824,
                        "name": "manage leave",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1824
                        }
                    },
                    {
                        "id": 1825,
                        "name": "create leave",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1825
                        }
                    },
                    {
                        "id": 1826,
                        "name": "edit leave",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1826
                        }
                    },
                    {
                        "id": 1827,
                        "name": "delete leave",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1827
                        }
                    },
                    {
                        "id": 1828,
                        "name": "manage leave type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1828
                        }
                    },
                    {
                        "id": 1829,
                        "name": "create leave type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1829
                        }
                    },
                    {
                        "id": 1830,
                        "name": "edit leave type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1830
                        }
                    },
                    {
                        "id": 1831,
                        "name": "delete leave type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1831
                        }
                    },
                    {
                        "id": 1832,
                        "name": "manage attendance",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1832
                        }
                    },
                    {
                        "id": 1833,
                        "name": "create attendance",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1833
                        }
                    },
                    {
                        "id": 1834,
                        "name": "edit attendance",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1834
                        }
                    },
                    {
                        "id": 1835,
                        "name": "delete attendance",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1835
                        }
                    },
                    {
                        "id": 1836,
                        "name": "manage report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1836
                        }
                    },
                    {
                        "id": 1837,
                        "name": "manage project",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1837
                        }
                    },
                    {
                        "id": 1838,
                        "name": "create project",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1838
                        }
                    },
                    {
                        "id": 1839,
                        "name": "view project",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1839
                        }
                    },
                    {
                        "id": 1840,
                        "name": "edit project",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1840
                        }
                    },
                    {
                        "id": 1841,
                        "name": "delete project",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1841
                        }
                    },
                    {
                        "id": 1842,
                        "name": "share project",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1842
                        }
                    },
                    {
                        "id": 1843,
                        "name": "view project expense",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1843
                        }
                    },
                    {
                        "id": 1844,
                        "name": "view project income",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1844
                        }
                    },
                    {
                        "id": 1845,
                        "name": "create milestone",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1845
                        }
                    },
                    {
                        "id": 1846,
                        "name": "edit milestone",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1846
                        }
                    },
                    {
                        "id": 1847,
                        "name": "delete milestone",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1847
                        }
                    },
                    {
                        "id": 1848,
                        "name": "view milestone",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1848
                        }
                    },
                    {
                        "id": 1849,
                        "name": "view grant chart",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1849
                        }
                    },
                    {
                        "id": 1850,
                        "name": "manage project stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1850
                        }
                    },
                    {
                        "id": 1851,
                        "name": "create project stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1851
                        }
                    },
                    {
                        "id": 1852,
                        "name": "edit project stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1852
                        }
                    },
                    {
                        "id": 1853,
                        "name": "delete project stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1853
                        }
                    },
                    {
                        "id": 1854,
                        "name": "view timesheet",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1854
                        }
                    },
                    {
                        "id": 1855,
                        "name": "view expense",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1855
                        }
                    },
                    {
                        "id": 1856,
                        "name": "manage project task",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1856
                        }
                    },
                    {
                        "id": 1857,
                        "name": "create project task",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1857
                        }
                    },
                    {
                        "id": 1858,
                        "name": "edit project task",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1858
                        }
                    },
                    {
                        "id": 1859,
                        "name": "view project task",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1859
                        }
                    },
                    {
                        "id": 1860,
                        "name": "delete project task",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1860
                        }
                    },
                    {
                        "id": 1861,
                        "name": "view activity",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1861
                        }
                    },
                    {
                        "id": 1862,
                        "name": "view CRM activity",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1862
                        }
                    },
                    {
                        "id": 1863,
                        "name": "manage project task stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1863
                        }
                    },
                    {
                        "id": 1864,
                        "name": "edit project task stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1864
                        }
                    },
                    {
                        "id": 1865,
                        "name": "create project task stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1865
                        }
                    },
                    {
                        "id": 1866,
                        "name": "delete project task stage",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1866
                        }
                    },
                    {
                        "id": 1867,
                        "name": "manage timesheet",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1867
                        }
                    },
                    {
                        "id": 1868,
                        "name": "manage matter timesheet",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1868
                        }
                    },
                    {
                        "id": 1869,
                        "name": "create timesheet",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1869
                        }
                    },
                    {
                        "id": 1870,
                        "name": "create matter timesheet",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1870
                        }
                    },
                    {
                        "id": 1871,
                        "name": "edit timesheet",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1871
                        }
                    },
                    {
                        "id": 1872,
                        "name": "edit matter timesheet",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1872
                        }
                    },
                    {
                        "id": 1873,
                        "name": "delete timesheet",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1873
                        }
                    },
                    {
                        "id": 1874,
                        "name": "delete matter timesheet",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1874
                        }
                    },
                    {
                        "id": 1875,
                        "name": "manage bug report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1875
                        }
                    },
                    {
                        "id": 1876,
                        "name": "create bug report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1876
                        }
                    },
                    {
                        "id": 1877,
                        "name": "edit bug report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1877
                        }
                    },
                    {
                        "id": 1878,
                        "name": "delete bug report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1878
                        }
                    },
                    {
                        "id": 1879,
                        "name": "move bug report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1879
                        }
                    },
                    {
                        "id": 1880,
                        "name": "manage bug status",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1880
                        }
                    },
                    {
                        "id": 1881,
                        "name": "create bug status",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1881
                        }
                    },
                    {
                        "id": 1882,
                        "name": "edit bug status",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1882
                        }
                    },
                    {
                        "id": 1883,
                        "name": "delete bug status",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1883
                        }
                    },
                    {
                        "id": 1886,
                        "name": "manage system settings",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1886
                        }
                    },
                    {
                        "id": 1887,
                        "name": "manage plan",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1887
                        }
                    },
                    {
                        "id": 1894,
                        "name": "manage company plan",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1894
                        }
                    },
                    {
                        "id": 1895,
                        "name": "buy plan",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1895
                        }
                    },
                    {
                        "id": 1896,
                        "name": "manage form builder",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1896
                        }
                    },
                    {
                        "id": 1897,
                        "name": "create form builder",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1897
                        }
                    },
                    {
                        "id": 1898,
                        "name": "edit form builder",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1898
                        }
                    },
                    {
                        "id": 1899,
                        "name": "delete form builder",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1899
                        }
                    },
                    {
                        "id": 1900,
                        "name": "manage performance type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1900
                        }
                    },
                    {
                        "id": 1901,
                        "name": "create performance type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1901
                        }
                    },
                    {
                        "id": 1902,
                        "name": "edit performance type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1902
                        }
                    },
                    {
                        "id": 1903,
                        "name": "delete performance type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1903
                        }
                    },
                    {
                        "id": 1904,
                        "name": "manage form field",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1904
                        }
                    },
                    {
                        "id": 1905,
                        "name": "create form field",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1905
                        }
                    },
                    {
                        "id": 1906,
                        "name": "edit form field",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1906
                        }
                    },
                    {
                        "id": 1907,
                        "name": "delete form field",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1907
                        }
                    },
                    {
                        "id": 1908,
                        "name": "view form response",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1908
                        }
                    },
                    {
                        "id": 1909,
                        "name": "create budget plan",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1909
                        }
                    },
                    {
                        "id": 1910,
                        "name": "edit budget plan",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1910
                        }
                    },
                    {
                        "id": 1911,
                        "name": "manage budget plan",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1911
                        }
                    },
                    {
                        "id": 1912,
                        "name": "delete budget plan",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1912
                        }
                    },
                    {
                        "id": 1913,
                        "name": "view budget plan",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1913
                        }
                    },
                    {
                        "id": 1914,
                        "name": "manage warehouse",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1914
                        }
                    },
                    {
                        "id": 1915,
                        "name": "create warehouse",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1915
                        }
                    },
                    {
                        "id": 1916,
                        "name": "edit warehouse",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1916
                        }
                    },
                    {
                        "id": 1917,
                        "name": "show warehouse",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1917
                        }
                    },
                    {
                        "id": 1918,
                        "name": "delete warehouse",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1918
                        }
                    },
                    {
                        "id": 1919,
                        "name": "manage purchase",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1919
                        }
                    },
                    {
                        "id": 1920,
                        "name": "create purchase",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1920
                        }
                    },
                    {
                        "id": 1921,
                        "name": "edit purchase",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1921
                        }
                    },
                    {
                        "id": 1922,
                        "name": "show purchase",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1922
                        }
                    },
                    {
                        "id": 1923,
                        "name": "delete purchase",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1923
                        }
                    },
                    {
                        "id": 1924,
                        "name": "send purchase",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1924
                        }
                    },
                    {
                        "id": 1925,
                        "name": "create payment purchase",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1925
                        }
                    },
                    {
                        "id": 1926,
                        "name": "manage pos",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1926
                        }
                    },
                    {
                        "id": 1927,
                        "name": "manage contract type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1927
                        }
                    },
                    {
                        "id": 1928,
                        "name": "create contract type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1928
                        }
                    },
                    {
                        "id": 1929,
                        "name": "edit contract type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1929
                        }
                    },
                    {
                        "id": 1930,
                        "name": "delete contract type",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1930
                        }
                    },
                    {
                        "id": 1931,
                        "name": "manage contract",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1931
                        }
                    },
                    {
                        "id": 1932,
                        "name": "create contract",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1932
                        }
                    },
                    {
                        "id": 1933,
                        "name": "edit contract",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1933
                        }
                    },
                    {
                        "id": 1934,
                        "name": "delete contract",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1934
                        }
                    },
                    {
                        "id": 1935,
                        "name": "show contract",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1935
                        }
                    },
                    {
                        "id": 1936,
                        "name": "create barcode",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1936
                        }
                    },
                    {
                        "id": 1937,
                        "name": "create webhook",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1937
                        }
                    },
                    {
                        "id": 1938,
                        "name": "edit webhook",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1938
                        }
                    },
                    {
                        "id": 1939,
                        "name": "delete webhook",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:18.000000Z",
                        "updated_at": "2026-01-09T12:12:18.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1939
                        }
                    },
                    {
                        "id": 1940,
                        "name": "manage batch",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:26.000000Z",
                        "updated_at": "2026-01-09T12:12:26.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1940
                        }
                    },
                    {
                        "id": 1941,
                        "name": "show batch",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:27.000000Z",
                        "updated_at": "2026-01-09T12:12:27.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1941
                        }
                    },
                    {
                        "id": 1942,
                        "name": "manage kds screen",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:27.000000Z",
                        "updated_at": "2026-01-09T12:12:27.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1942
                        }
                    },
                    {
                        "id": 1943,
                        "name": "show kds screen",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:27.000000Z",
                        "updated_at": "2026-01-09T12:12:27.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1943
                        }
                    },
                    {
                        "id": 1944,
                        "name": "kds operator login",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:28.000000Z",
                        "updated_at": "2026-01-09T12:12:28.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1944
                        }
                    },
                    {
                        "id": 1945,
                        "name": "kds report defects",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:28.000000Z",
                        "updated_at": "2026-01-09T12:12:28.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1945
                        }
                    },
                    {
                        "id": 1946,
                        "name": "kds consume materials",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:29.000000Z",
                        "updated_at": "2026-01-09T12:12:29.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1946
                        }
                    },
                    {
                        "id": 1947,
                        "name": "kds view assigned operations",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:29.000000Z",
                        "updated_at": "2026-01-09T12:12:29.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1947
                        }
                    },
                    {
                        "id": 1948,
                        "name": "kds supervisor dashboard",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:29.000000Z",
                        "updated_at": "2026-01-09T12:12:29.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1948
                        }
                    },
                    {
                        "id": 1949,
                        "name": "kds reassign operations",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:30.000000Z",
                        "updated_at": "2026-01-09T12:12:30.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1949
                        }
                    },
                    {
                        "id": 1950,
                        "name": "kds override priority",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:30.000000Z",
                        "updated_at": "2026-01-09T12:12:30.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1950
                        }
                    },
                    {
                        "id": 1951,
                        "name": "kds view all workstations",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:31.000000Z",
                        "updated_at": "2026-01-09T12:12:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1951
                        }
                    },
                    {
                        "id": 1952,
                        "name": "kds manage alerts",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:31.000000Z",
                        "updated_at": "2026-01-09T12:12:31.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1952
                        }
                    },
                    {
                        "id": 1953,
                        "name": "kds configure settings",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:32.000000Z",
                        "updated_at": "2026-01-09T12:12:32.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1953
                        }
                    },
                    {
                        "id": 1954,
                        "name": "kds manage operators",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:32.000000Z",
                        "updated_at": "2026-01-09T12:12:32.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1954
                        }
                    },
                    {
                        "id": 1955,
                        "name": "kds view analytics",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:32.000000Z",
                        "updated_at": "2026-01-09T12:12:32.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1955
                        }
                    },
                    {
                        "id": 1956,
                        "name": "manage production plan",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:33.000000Z",
                        "updated_at": "2026-01-09T12:12:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1956
                        }
                    },
                    {
                        "id": 1957,
                        "name": "create production plan",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:33.000000Z",
                        "updated_at": "2026-01-09T12:12:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1957
                        }
                    },
                    {
                        "id": 1958,
                        "name": "edit production plan",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:34.000000Z",
                        "updated_at": "2026-01-09T12:12:34.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1958
                        }
                    },
                    {
                        "id": 1959,
                        "name": "delete production plan",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:34.000000Z",
                        "updated_at": "2026-01-09T12:12:34.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1959
                        }
                    },
                    {
                        "id": 1960,
                        "name": "show production plan",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:34.000000Z",
                        "updated_at": "2026-01-09T12:12:34.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1960
                        }
                    },
                    {
                        "id": 1961,
                        "name": "show production report",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:35.000000Z",
                        "updated_at": "2026-01-09T12:12:35.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1961
                        }
                    },
                    {
                        "id": 1962,
                        "name": "manage picking slips",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:35.000000Z",
                        "updated_at": "2026-01-09T12:12:35.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1962
                        }
                    },
                    {
                        "id": 1963,
                        "name": "create picking slips",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:36.000000Z",
                        "updated_at": "2026-01-09T12:12:36.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1963
                        }
                    },
                    {
                        "id": 1964,
                        "name": "edit picking slips",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:36.000000Z",
                        "updated_at": "2026-01-09T12:12:36.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1964
                        }
                    },
                    {
                        "id": 1965,
                        "name": "show picking slips",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:37.000000Z",
                        "updated_at": "2026-01-09T12:12:37.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1965
                        }
                    },
                    {
                        "id": 1966,
                        "name": "delete picking slips",
                        "guard_name": "web",
                        "created_at": "2026-01-09T12:12:37.000000Z",
                        "updated_at": "2026-01-09T12:12:37.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1966
                        }
                    },
                    {
                        "id": 1967,
                        "name": "manage sprint",
                        "guard_name": "web",
                        "created_at": "2026-01-14T19:17:33.000000Z",
                        "updated_at": "2026-01-14T19:17:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1967
                        }
                    },
                    {
                        "id": 1968,
                        "name": "create sprint",
                        "guard_name": "web",
                        "created_at": "2026-01-14T19:17:33.000000Z",
                        "updated_at": "2026-01-14T19:17:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1968
                        }
                    },
                    {
                        "id": 1969,
                        "name": "edit sprint",
                        "guard_name": "web",
                        "created_at": "2026-01-14T19:17:33.000000Z",
                        "updated_at": "2026-01-14T19:17:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1969
                        }
                    },
                    {
                        "id": 1970,
                        "name": "view sprint",
                        "guard_name": "web",
                        "created_at": "2026-01-14T19:17:33.000000Z",
                        "updated_at": "2026-01-14T19:17:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1970
                        }
                    },
                    {
                        "id": 1971,
                        "name": "delete sprint",
                        "guard_name": "web",
                        "created_at": "2026-01-14T19:17:33.000000Z",
                        "updated_at": "2026-01-14T19:17:33.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1971
                        }
                    },
                    {
                        "id": 1972,
                        "name": "manage late",
                        "guard_name": "web",
                        "created_at": "2026-01-18T13:32:36.000000Z",
                        "updated_at": "2026-01-18T13:32:36.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1972
                        }
                    },
                    {
                        "id": 1973,
                        "name": "show late",
                        "guard_name": "web",
                        "created_at": "2026-01-18T13:32:36.000000Z",
                        "updated_at": "2026-01-18T13:32:36.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1973
                        }
                    },
                    {
                        "id": 1974,
                        "name": "create late",
                        "guard_name": "web",
                        "created_at": "2026-01-18T13:32:36.000000Z",
                        "updated_at": "2026-01-18T13:32:36.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1974
                        }
                    },
                    {
                        "id": 1975,
                        "name": "edit late",
                        "guard_name": "web",
                        "created_at": "2026-01-18T13:32:36.000000Z",
                        "updated_at": "2026-01-18T13:32:36.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1975
                        }
                    },
                    {
                        "id": 1976,
                        "name": "delete late",
                        "guard_name": "web",
                        "created_at": "2026-01-18T13:32:37.000000Z",
                        "updated_at": "2026-01-18T13:32:37.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1976
                        }
                    },
                    {
                        "id": 1977,
                        "name": "manage purchase notification setting",
                        "guard_name": "web",
                        "created_at": "2026-01-18T13:32:37.000000Z",
                        "updated_at": "2026-01-18T13:32:37.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1977
                        }
                    },
                    {
                        "id": 1978,
                        "name": "manage subtask",
                        "guard_name": "web",
                        "created_at": "2026-01-21T12:04:04.000000Z",
                        "updated_at": "2026-01-21T12:04:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1978
                        }
                    },
                    {
                        "id": 1979,
                        "name": "create subtask",
                        "guard_name": "web",
                        "created_at": "2026-01-21T12:04:04.000000Z",
                        "updated_at": "2026-01-21T12:04:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1979
                        }
                    },
                    {
                        "id": 1980,
                        "name": "view subtask",
                        "guard_name": "web",
                        "created_at": "2026-01-21T12:04:04.000000Z",
                        "updated_at": "2026-01-21T12:04:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1980
                        }
                    },
                    {
                        "id": 1981,
                        "name": "edit subtask",
                        "guard_name": "web",
                        "created_at": "2026-01-21T12:04:04.000000Z",
                        "updated_at": "2026-01-21T12:04:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1981
                        }
                    },
                    {
                        "id": 1982,
                        "name": "delete subtask",
                        "guard_name": "web",
                        "created_at": "2026-01-21T12:04:04.000000Z",
                        "updated_at": "2026-01-21T12:04:04.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1982
                        }
                    },
                    {
                        "id": 1983,
                        "name": "manage bonus type",
                        "guard_name": "web",
                        "created_at": "2026-01-26T09:23:42.000000Z",
                        "updated_at": "2026-01-26T09:23:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1983
                        }
                    },
                    {
                        "id": 1984,
                        "name": "create bonus type",
                        "guard_name": "web",
                        "created_at": "2026-01-26T09:23:42.000000Z",
                        "updated_at": "2026-01-26T09:23:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1984
                        }
                    },
                    {
                        "id": 1985,
                        "name": "edit bonus type",
                        "guard_name": "web",
                        "created_at": "2026-01-26T09:23:42.000000Z",
                        "updated_at": "2026-01-26T09:23:42.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1985
                        }
                    },
                    {
                        "id": 1986,
                        "name": "delete bonus type",
                        "guard_name": "web",
                        "created_at": "2026-01-26T09:23:43.000000Z",
                        "updated_at": "2026-01-26T09:23:43.000000Z",
                        "pivot": {
                            "role_id": 4,
                            "permission_id": 1986
                        }
                    }
                ]
            }
        ],
        "permissions": [
            {
                "id": 1967,
                "name": "manage sprint",
                "guard_name": "web",
                "created_at": "2026-01-14T19:17:33.000000Z",
                "updated_at": "2026-01-14T19:17:33.000000Z",
                "pivot": {
                    "model_id": 3,
                    "permission_id": 1967,
                    "model_type": "App\\Models\\User"
                }
            },
            {
                "id": 1968,
                "name": "create sprint",
                "guard_name": "web",
                "created_at": "2026-01-14T19:17:33.000000Z",
                "updated_at": "2026-01-14T19:17:33.000000Z",
                "pivot": {
                    "model_id": 3,
                    "permission_id": 1968,
                    "model_type": "App\\Models\\User"
                }
            },
            {
                "id": 1969,
                "name": "edit sprint",
                "guard_name": "web",
                "created_at": "2026-01-14T19:17:33.000000Z",
                "updated_at": "2026-01-14T19:17:33.000000Z",
                "pivot": {
                    "model_id": 3,
                    "permission_id": 1969,
                    "model_type": "App\\Models\\User"
                }
            },
            {
                "id": 1970,
                "name": "view sprint",
                "guard_name": "web",
                "created_at": "2026-01-14T19:17:33.000000Z",
                "updated_at": "2026-01-14T19:17:33.000000Z",
                "pivot": {
                    "model_id": 3,
                    "permission_id": 1970,
                    "model_type": "App\\Models\\User"
                }
            },
            {
                "id": 1971,
                "name": "delete sprint",
                "guard_name": "web",
                "created_at": "2026-01-14T19:17:33.000000Z",
                "updated_at": "2026-01-14T19:17:33.000000Z",
                "pivot": {
                    "model_id": 3,
                    "permission_id": 1971,
                    "model_type": "App\\Models\\User"
                }
            }
        ]
    },
    "operator": null,
    "roles": [
        "company"
    ],
    "permissions": [
        "show pos dashboard",
        "show crm dashboard",
        "show hrm dashboard",
        "copy invoice",
        "show project dashboard",
        "show matter dashboard",
        "show account dashboard",
        "manage user",
        "create user",
        "edit user",
        "delete user",
        "manage role",
        "create role",
        "edit role",
        "delete role",
        "manage permission",
        "create permission",
        "edit permission",
        "delete permission",
        "manage print settings",
        "manage business settings",
        "manage expense",
        "create expense",
        "edit expense",
        "delete expense",
        "manage invoice",
        "create invoice",
        "edit invoice",
        "delete invoice",
        "show invoice",
        "create payment invoice",
        "delete payment invoice",
        "send invoice",
        "delete invoice product",
        "convert invoice",
        "manage constant unit",
        "create constant unit",
        "edit constant unit",
        "delete constant unit",
        "manage constant tax",
        "create constant tax",
        "edit constant tax",
        "delete constant tax",
        "manage constant category",
        "create constant category",
        "edit constant category",
        "delete constant category",
        "manage items",
        "create items",
        "edit items",
        "delete items",
        "manage customer",
        "create customer",
        "edit customer",
        "delete customer",
        "show customer",
        "manage bank account",
        "create bank account",
        "edit bank account",
        "delete bank account",
        "manage bank",
        "create bank",
        "edit bank",
        "delete bank",
        "manage bank transfer",
        "create bank transfer",
        "edit bank transfer",
        "delete bank transfer",
        "manage transaction",
        "manage revenue",
        "create revenue",
        "edit revenue",
        "delete revenue",
        "manage bill",
        "create bill",
        "edit bill",
        "delete bill",
        "show bill",
        "manage payment",
        "create payment",
        "edit payment",
        "delete payment",
        "delete bill product",
        "send bill",
        "create payment bill",
        "delete payment bill",
        "manage order",
        "manage order status change",
        "income report",
        "expense report",
        "income vs expense report",
        "invoice report",
        "bill report",
        "stock report",
        "tax report",
        "loss & profit report",
        "manage credit note",
        "create credit note",
        "edit credit note",
        "delete credit note",
        "manage debit note",
        "create debit note",
        "edit debit note",
        "delete debit note",
        "duplicate invoice",
        "duplicate bill",
        "manage goal",
        "create goal",
        "edit goal",
        "delete goal",
        "manage assets",
        "create assets",
        "edit assets",
        "delete assets",
        "statement report",
        "manage constant custom field",
        "create constant custom field",
        "edit constant custom field",
        "delete constant custom field",
        "manage chart of account",
        "create chart of account",
        "edit chart of account",
        "delete chart of account",
        "manage chart of account type",
        "create chart of account type",
        "edit chart of account type",
        "delete chart of account type",
        "manage chart of account sub type",
        "create chart of account sub type",
        "edit chart of account sub type",
        "delete chart of account sub type",
        "manage journal entry",
        "create journal entry",
        "edit journal entry",
        "delete journal entry",
        "show journal entry",
        "balance sheet report",
        "ledger report",
        "trial balance report",
        "manage client",
        "create client",
        "edit client",
        "delete client",
        "manage lead",
        "create lead",
        "view lead",
        "edit lead",
        "delete lead",
        "move lead",
        "create lead call",
        "edit lead call",
        "delete lead call",
        "create lead email",
        "manage pipeline",
        "create pipeline",
        "edit pipeline",
        "delete pipeline",
        "manage lead stage",
        "create lead stage",
        "edit lead stage",
        "delete lead stage",
        "convert lead to deal",
        "manage source",
        "create source",
        "edit source",
        "delete source",
        "manage label",
        "create label",
        "edit label",
        "delete label",
        "manage deal",
        "create deal",
        "view task",
        "create task",
        "edit task",
        "delete task",
        "edit deal",
        "view deal",
        "delete deal",
        "move deal",
        "create deal call",
        "edit deal call",
        "delete deal call",
        "create deal email",
        "manage stage",
        "create stage",
        "edit stage",
        "delete stage",
        "manage employee",
        "create employee",
        "view employee",
        "edit employee",
        "delete employee",
        "manage employee profile",
        "show employee profile",
        "manage department",
        "create department",
        "view department",
        "edit department",
        "delete department",
        "manage designation",
        "create designation",
        "view designation",
        "edit designation",
        "delete designation",
        "manage branch",
        "create branch",
        "edit branch",
        "delete branch",
        "manage document type",
        "create document type",
        "edit document type",
        "delete document type",
        "manage document",
        "create document",
        "edit document",
        "delete document",
        "manage payslip type",
        "create payslip type",
        "edit payslip type",
        "delete payslip type",
        "create allowance",
        "edit allowance",
        "delete allowance",
        "create commission",
        "edit commission",
        "delete commission",
        "manage allowance option",
        "create allowance option",
        "edit allowance option",
        "delete allowance option",
        "manage loan option",
        "create loan option",
        "edit loan option",
        "delete loan option",
        "manage deduction option",
        "create deduction option",
        "edit deduction option",
        "delete deduction option",
        "create loan",
        "edit loan",
        "delete loan",
        "create other deduction",
        "edit other deduction",
        "delete other deduction",
        "create other payment",
        "edit other payment",
        "delete other payment",
        "create overtime",
        "edit overtime",
        "delete overtime",
        "manage set salary",
        "edit set salary",
        "manage pay slip",
        "create set salary",
        "create pay slip",
        "manage company policy",
        "create company policy",
        "edit company policy",
        "manage appraisal",
        "create appraisal",
        "edit appraisal",
        "show appraisal",
        "delete appraisal",
        "manage goal tracking",
        "create goal tracking",
        "edit goal tracking",
        "delete goal tracking",
        "manage goal type",
        "create goal type",
        "edit goal type",
        "delete goal type",
        "manage indicator",
        "create indicator",
        "edit indicator",
        "show indicator",
        "delete indicator",
        "manage training",
        "create training",
        "edit training",
        "delete training",
        "show training",
        "manage trainer",
        "create trainer",
        "edit trainer",
        "delete trainer",
        "manage training type",
        "create training type",
        "edit training type",
        "delete training type",
        "manage award",
        "create award",
        "edit award",
        "delete award",
        "manage award type",
        "create award type",
        "edit award type",
        "delete award type",
        "manage resignation",
        "create resignation",
        "edit resignation",
        "delete resignation",
        "manage travel",
        "create travel",
        "edit travel",
        "delete travel",
        "manage promotion",
        "create promotion",
        "edit promotion",
        "delete promotion",
        "manage complaint",
        "create complaint",
        "edit complaint",
        "delete complaint",
        "manage warning",
        "create warning",
        "edit warning",
        "delete warning",
        "manage termination",
        "create termination",
        "edit termination",
        "delete termination",
        "manage termination type",
        "create termination type",
        "edit termination type",
        "delete termination type",
        "manage job application",
        "create job application",
        "show job application",
        "delete job application",
        "move job application",
        "add job application skill",
        "add job application note",
        "delete job application note",
        "manage job onBoard",
        "manage job category",
        "create job category",
        "edit job category",
        "delete job category",
        "manage job",
        "create job",
        "edit job",
        "show job",
        "delete job",
        "manage job stage",
        "create job stage",
        "edit job stage",
        "delete job stage",
        "Manage Competencies",
        "Create Competencies",
        "Edit Competencies",
        "Delete Competencies",
        "manage custom question",
        "create custom question",
        "edit custom question",
        "delete custom question",
        "create interview schedule",
        "edit interview schedule",
        "delete interview schedule",
        "show interview schedule",
        "create estimation",
        "view estimation",
        "edit estimation",
        "delete estimation",
        "edit holiday",
        "create holiday",
        "delete holiday",
        "manage holiday",
        "show career",
        "manage meeting",
        "create meeting",
        "edit meeting",
        "delete meeting",
        "manage event",
        "create event",
        "edit event",
        "delete event",
        "manage transfer",
        "create transfer",
        "edit transfer",
        "delete transfer",
        "manage announcement",
        "create announcement",
        "edit announcement",
        "delete announcement",
        "manage leave",
        "create leave",
        "edit leave",
        "delete leave",
        "manage leave type",
        "create leave type",
        "edit leave type",
        "delete leave type",
        "manage attendance",
        "create attendance",
        "edit attendance",
        "delete attendance",
        "manage report",
        "manage project",
        "create project",
        "view project",
        "edit project",
        "delete project",
        "share project",
        "create milestone",
        "edit milestone",
        "delete milestone",
        "view milestone",
        "view grant chart",
        "manage project stage",
        "create project stage",
        "edit project stage",
        "delete project stage",
        "view timesheet",
        "view expense",
        "manage project task",
        "create project task",
        "edit project task",
        "view project task",
        "delete project task",
        "view activity",
        "view CRM activity",
        "manage project task stage",
        "edit project task stage",
        "create project task stage",
        "delete project task stage",
        "manage timesheet",
        "manage matter timesheet",
        "create timesheet",
        "create matter timesheet",
        "edit timesheet",
        "edit matter timesheet",
        "delete timesheet",
        "delete matter timesheet",
        "manage bug report",
        "create bug report",
        "edit bug report",
        "delete bug report",
        "move bug report",
        "manage bug status",
        "create bug status",
        "edit bug status",
        "delete bug status",
        "manage system settings",
        "manage plan",
        "manage company plan",
        "buy plan",
        "manage form builder",
        "create form builder",
        "edit form builder",
        "delete form builder",
        "manage performance type",
        "create performance type",
        "edit performance type",
        "delete performance type",
        "manage form field",
        "create form field",
        "edit form field",
        "delete form field",
        "view form response",
        "create budget plan",
        "edit budget plan",
        "manage budget plan",
        "delete budget plan",
        "view budget plan",
        "manage warehouse",
        "create warehouse",
        "edit warehouse",
        "show warehouse",
        "delete warehouse",
        "manage purchase",
        "create purchase",
        "edit purchase",
        "show purchase",
        "delete purchase",
        "send purchase",
        "create payment purchase",
        "manage pos",
        "manage contract type",
        "create contract type",
        "edit contract type",
        "delete contract type",
        "manage contract",
        "create contract",
        "edit contract",
        "delete contract",
        "show contract",
        "create barcode",
        "create webhook",
        "edit webhook",
        "delete webhook",
        "manage verify user",
        "manage company settings",
        "manage audit_logs",
        "create audit_logs",
        "edit audit_logs",
        "show audit_logs",
        "delete audit_logs",
        "manage api",
        "show api",
        "create api",
        "edit api",
        "delete api",
        "show PFI",
        "manage customer settings",
        "manage vendor settings",
        "show vendor",
        "show hrm reports",
        "show distributor dashboard",
        "show distributor report",
        "manage employee system access",
        "manage employee card",
        "create employee card",
        "edit employee card",
        "delete employee card",
        "show items",
        "manage warehouse product",
        "show warehouse product",
        "create warehouse product",
        "delete warehouse product",
        "edit warehouse product",
        "manage petty cash status",
        "show petty cash status",
        "create petty cash status",
        "delete petty cash status",
        "edit petty cash status",
        "manage stock adjustment",
        "show inventory dashboard",
        "show inventory report",
        "show asset dashboard",
        "show asset report",
        "show stock adjustment",
        "create stock adjustment",
        "delete stock adjustment",
        "edit stock adjustment",
        "manage distributor settings",
        "manage distributor notification setting",
        "manage distributor",
        "show distributor",
        "create distributor",
        "delete distributor",
        "edit distributor",
        "manage loading instruction",
        "show loading instruction",
        "create loading instruction",
        "delete loading instruction",
        "edit loading instruction",
        "manage distributor type",
        "show distributor type",
        "create distributor type",
        "delete distributor type",
        "edit distributor type",
        "manage distributor attachment type",
        "show distributor attachment type",
        "create distributor attachment type",
        "delete distributor attachment type",
        "edit distributor attachment type",
        "manage distributor item",
        "show distributor item",
        "create distributor item",
        "delete distributor item",
        "edit distributor item",
        "manage distributor order",
        "show distributor order",
        "create distributor order",
        "delete distributor order",
        "edit distributor order",
        "manage reassigned distributor order",
        "manage wholesaler price",
        "show wholesaler price",
        "create wholesaler price",
        "delete wholesaler price",
        "edit wholesaler price",
        "manage super dealer zone",
        "show super dealer zone",
        "create super dealer zone",
        "delete super dealer zone",
        "edit super dealer zone",
        "manage asset",
        "show asset",
        "create asset",
        "delete asset",
        "edit asset",
        "show bank",
        "manage accessory",
        "show accessory",
        "create accessory",
        "delete accessory",
        "edit accessory",
        "manage database backup",
        "manage asset log",
        "show asset log",
        "manage asset label",
        "show asset label",
        "create asset label",
        "manage asset maintenance type",
        "show asset maintenance type",
        "create asset maintenance type",
        "delete asset maintenance type",
        "edit asset maintenance type",
        "manage asset maintenance",
        "show asset maintenance",
        "create asset maintenance",
        "delete asset maintenance",
        "edit asset maintenance",
        "manage asset status",
        "show asset status",
        "create asset status",
        "delete asset status",
        "edit asset status",
        "manage asset model",
        "show asset model",
        "create asset model",
        "delete asset model",
        "edit asset model",
        "manage asset category",
        "show asset category",
        "create asset category",
        "delete asset category",
        "edit asset category",
        "manage asset manufacture",
        "show asset manufacture",
        "create asset manufacture",
        "delete asset manufacture",
        "edit asset manufacture",
        "manage asset depreciation",
        "show asset depreciation",
        "create asset depreciation",
        "delete asset depreciation",
        "edit asset depreciation",
        "manage asset company",
        "show asset company",
        "create asset company",
        "delete asset company",
        "edit asset company",
        "manage asset location",
        "show asset location",
        "create asset location",
        "delete asset location",
        "edit asset location",
        "manage asset settings",
        "show asset settings",
        "create asset settings",
        "delete asset settings",
        "edit asset settings",
        "manage asset consumable",
        "show asset consumable",
        "create asset consumable",
        "delete asset consumable",
        "edit asset consumable",
        "manage asset component",
        "show asset component",
        "create asset component",
        "delete asset component",
        "edit asset component",
        "manage asset license",
        "show asset license",
        "create asset license",
        "delete asset license",
        "edit asset license",
        "manage asset accessory",
        "show asset accessory",
        "create asset accessory",
        "delete asset accessory",
        "edit asset accessory",
        "manage third part api",
        "show third part api",
        "create third part api",
        "manage stock transfer",
        "show stock transfer",
        "create stock transfer",
        "delete stock transfer",
        "edit stock transfer",
        "manage stock request approve",
        "manage stock transfer request",
        "show stock transfer request",
        "create stock transfer request",
        "delete stock transfer request",
        "edit stock transfer request",
        "manage delivery note",
        "show delivery note",
        "create delivery note",
        "delete delivery note",
        "edit delivery note",
        "manage goods receiving",
        "show goods receiving",
        "create goods receiving",
        "delete goods receiving",
        "edit goods receiving",
        "manage inventory settings",
        "show inventory settings",
        "create inventory settings",
        "delete inventory settings",
        "edit inventory settings",
        "manage delivery settings",
        "show delivery settings",
        "create delivery settings",
        "delete delivery settings",
        "edit delivery settings",
        "manage stock adjustment status",
        "show stock adjustment status",
        "create stock adjustment status",
        "delete stock adjustment status",
        "edit stock adjustment status",
        "manage items_stock",
        "show other salary",
        "manage other salary payment",
        "manage other salary",
        "create other salary",
        "edit other salary",
        "delete other salary",
        "show salary advance",
        "manage salary advance payment",
        "manage salary advance",
        "create salary advance",
        "edit salary advance",
        "delete salary advance",
        "manage salary advance status",
        "create salary advance status",
        "edit salary advance status",
        "delete salary advance status",
        "manage vendor",
        "create vendor",
        "edit vendor",
        "delete vendor",
        "manage vendor client",
        "create vendor client",
        "edit vendor client",
        "delete vendor client",
        "show vendor client",
        "manage vendor category",
        "create vendor category",
        "edit vendor category",
        "delete vendor category",
        "show vendor category",
        "manage vendor bank",
        "create vendor bank",
        "edit vendor bank",
        "delete vendor bank",
        "show vendor bank",
        "manage vendor attachment settings",
        "create vendor attachment settings",
        "edit vendor attachment settings",
        "delete vendor attachment settings",
        "show vendor attachment settings",
        "manage vendor payment term",
        "create vendor payment term",
        "edit vendor payment term",
        "delete vendor payment term",
        "show vendor payment term",
        "manage payment invoice",
        "show payment invoice",
        "edit payment invoice",
        "manage invoice status",
        "manage PFI credit note",
        "create PFI credit note",
        "edit PFI credit note",
        "delete PFI credit note",
        "manage PFI Status",
        "manage PFI",
        "create PFI",
        "edit PFI",
        "delete PFI",
        "duplicate PFI",
        "send PFI",
        "manage PFI payment",
        "create PFI payment",
        "edit PFI payment",
        "delete PFI payment",
        "show PFI payment",
        "manage reminders",
        "manage lead reminder",
        "create lead reminder",
        "show lead reminder",
        "edit lead reminder",
        "delete lead reminder",
        "manage deal reminder",
        "create deal reminder",
        "show deal reminder",
        "edit deal reminder",
        "delete deal reminder",
        "view lead task",
        "create lead task",
        "edit lead task",
        "delete lead task",
        "manage employee type",
        "create employee type",
        "view employee type",
        "edit employee type",
        "delete employee type",
        "manage employee bank",
        "create employee bank",
        "view employee bank",
        "edit employee bank",
        "delete employee bank",
        "manage employee kye",
        "view employee kye",
        "create employee kye",
        "edit employee kye",
        "delete employee kye",
        "view branch",
        "manage probation status",
        "show probation status",
        "create probation status",
        "edit probation status",
        "delete probation status",
        "manage probation",
        "show probation",
        "create probation",
        "edit probation",
        "delete probation",
        "manage kpi",
        "show kpi",
        "create kpi",
        "edit kpi",
        "delete kpi",
        "manage kpi title",
        "show kpi title",
        "create kpi title",
        "edit kpi title",
        "delete kpi title",
        "manage kpi objective",
        "show kpi objective",
        "create kpi objective",
        "edit kpi objective",
        "delete kpi objective",
        "manage hrm supervisor",
        "show hrm supervisor",
        "create hrm supervisor",
        "edit hrm supervisor",
        "delete hrm supervisor",
        "manage kpi form",
        "show kpi form",
        "create kpi form",
        "edit kpi form",
        "delete kpi form",
        "manage leave status",
        "view leave status",
        "create leave status",
        "edit leave status",
        "delete leave status",
        "create income tax rate",
        "edit income tax rate",
        "delete income tax rate",
        "manage vender dashboard",
        "manage overtime",
        "show overtime",
        "manage salary payment",
        "create salary payment",
        "edit salary payment",
        "edit pay slip",
        "delete pay slip",
        "show sales dashboard",
        "show sales report",
        "show purchase dashboard",
        "show purchase report",
        "show resignation",
        "manage custom report",
        "show custom report",
        "create custom report",
        "edit custom report",
        "delete custom report",
        "manage connect email",
        "show connect email",
        "create connect email",
        "edit connect email",
        "edit statutory deduction",
        "create statutory deduction",
        "delete statutory deduction",
        "manage statutory deduction",
        "show announcement",
        "show leave",
        "manage hrm settings",
        "create hrm settings",
        "manage matter",
        "create matter",
        "view matter",
        "edit matter",
        "delete matter",
        "share matter",
        "manage matter stage",
        "create matter stage",
        "edit matter stage",
        "delete matter stage",
        "manage matter task",
        "create matter task",
        "edit matter task",
        "view matter task",
        "delete matter task",
        "manage project settings",
        "manage matter task stage",
        "create matter task stage",
        "edit matter task stage",
        "delete matter task stage",
        "manage matter settings",
        "manage items settings",
        "manage contract settings",
        "manage contract status",
        "create contract status",
        "edit contract status",
        "delete contract status",
        "show contract status",
        "show logistic dashboard",
        "show logistic report",
        "manage request",
        "create request",
        "edit request",
        "show request",
        "delete request",
        "manage budget_matrix",
        "create budget_matrix",
        "edit budget_matrix",
        "show budget_matrix",
        "delete budget_matrix",
        "manage orders",
        "create orders invoice",
        "create orders",
        "edit orders",
        "show orders",
        "delete orders",
        "manage price list",
        "manage trip",
        "create trip",
        "edit trip",
        "show trip",
        "delete trip",
        "manage journey",
        "create journey",
        "edit journey",
        "show journey",
        "delete journey",
        "manage journey status change",
        "manage vehicle",
        "create vehicle",
        "edit vehicle",
        "show vehicle",
        "delete vehicle",
        "manage manifest report",
        "create manifest report",
        "edit manifest report",
        "show manifest report",
        "delete manifest report",
        "manage cash report",
        "show cash report",
        "manage order report",
        "show order report",
        "manage sales report",
        "manage aging report",
        "show aging report",
        "manage statement of account",
        "show statement of account",
        "manage vehicle_assignment",
        "create vehicle_assignment",
        "edit vehicle_assignment",
        "show vehicle_assignment",
        "delete vehicle_assignment",
        "manage coordinate",
        "create coordinate",
        "edit coordinate",
        "show coordinate",
        "delete coordinate",
        "manage meter_history",
        "create meter_history",
        "edit meter_history",
        "show meter_history",
        "delete meter_history",
        "manage expense_history",
        "create expense_history",
        "edit expense_history",
        "show expense_history",
        "delete expense_history",
        "manage routes",
        "create routes",
        "edit routes",
        "show routes",
        "delete routes",
        "manage inventory",
        "create inventory",
        "edit inventory",
        "show inventory",
        "delete inventory",
        "manage machine",
        "create machine",
        "edit machine",
        "show machine",
        "delete machine",
        "manage jobcard close",
        "manage jobcard status",
        "create jobcard status",
        "edit jobcard status",
        "show jobcard status",
        "delete jobcard status",
        "manage inspection",
        "create inspection",
        "edit inspection",
        "show inspection",
        "delete inspection",
        "manage fuel",
        "create fuel",
        "edit fuel",
        "show fuel",
        "delete fuel",
        "manage job_card",
        "create job_card",
        "edit job_card",
        "show job_card",
        "delete job_card",
        "manage jobcard dashboard",
        "manage jobcard report",
        "manage jobcard_settings",
        "create jobcard_settings",
        "edit jobcard_settings",
        "show jobcard_settings",
        "delete jobcard_settings",
        "manage operator",
        "create operator",
        "edit operator",
        "show operator",
        "delete operator",
        "manage general_settings",
        "create general_settings",
        "edit general_settings",
        "manage vehicle_settings",
        "create vehicle_settings",
        "edit vehicle_settings",
        "show vehicle_settings",
        "delete vehicle_settings",
        "manage routes_settings",
        "create routes_settings",
        "edit routes_settings",
        "show routes_settings",
        "delete routes_settings",
        "manage orders_settings",
        "create orders_settings",
        "edit orders_settings",
        "show orders_settings",
        "delete orders_settings",
        "manage vehicle_departure_schedule",
        "create vehicle_departure_schedule",
        "edit vehicle_departure_schedule",
        "show vehicle_departure_schedule",
        "delete vehicle_departure_schedule",
        "manage trip_settings",
        "create trip_settings",
        "edit trip_settings",
        "show trip_settings",
        "delete trip_settings",
        "manage workshop_settings",
        "create workshop_settings",
        "edit workshop_settings",
        "show workshop_settings",
        "delete workshop_settings",
        "manage request_settings",
        "create request_settings",
        "edit request_settings",
        "show request_settings",
        "delete request_settings",
        "manage operator_settings",
        "create operator_settings",
        "edit operator_settings",
        "show operator_settings",
        "delete operator_settings",
        "manage tire",
        "create tire",
        "edit tire",
        "show tire",
        "delete tire",
        "manage tire operation",
        "create tire operation",
        "edit tire operation",
        "show tire operation",
        "delete tire operation",
        "manage tire_settings",
        "create tire_settings",
        "edit tire_settings",
        "show tire_settings",
        "delete tire_settings",
        "manage workshop",
        "create workshop",
        "edit workshop",
        "show workshop",
        "delete workshop",
        "manage report_builder",
        "create report_builder",
        "edit report_builder",
        "show report_builder",
        "delete report_builder",
        "manage sales_settings",
        "create sales_settings",
        "edit sales_settings",
        "show sales_settings",
        "delete sales_settings",
        "manage weighbridge settings",
        "create weighbridge settings",
        "edit weighbridge settings",
        "show weighbridge settings",
        "delete weighbridge settings",
        "manage map_settings",
        "create map_settings",
        "edit map_settings",
        "show map_settings",
        "delete map_settings",
        "manage approval settings",
        "create approval settings",
        "edit approval settings",
        "show approval settings",
        "delete approval settings",
        "manage purchase quotation",
        "create purchase quotation",
        "edit purchase quotation",
        "show purchase quotation",
        "delete purchase quotation",
        "send purchase quotation",
        "manage purchase order",
        "create purchase order",
        "edit purchase order",
        "show purchase order",
        "delete purchase order",
        "send purchase order",
        "manage purchase order status",
        "manage purchase order payment",
        "create purchase order payment",
        "edit purchase order payment",
        "show purchase order payment",
        "delete purchase order payment",
        "manage purchases_list",
        "create purchases_list",
        "edit purchases_list",
        "show purchases_list",
        "delete purchases_list",
        "manage purchase_request",
        "create purchase_request",
        "edit purchase_request",
        "show purchase_request",
        "delete purchase_request",
        "manage telematics",
        "show telematics",
        "manage vehicle_monitor",
        "create vehicle_monitor",
        "edit vehicle_monitor",
        "show vehicle_monitor",
        "delete vehicle_monitor",
        "manage purchases_settings",
        "create purchases_settings",
        "edit purchases_settings",
        "show purchases_settings",
        "delete purchases_settings",
        "manage petty_cash balance sync",
        "manage petty_cash",
        "create petty_cash",
        "edit petty_cash",
        "show petty_cash",
        "delete petty_cash",
        "create lead meeting",
        "edit lead meeting",
        "delete lead meeting",
        "manage petty_cash_request",
        "create petty_cash_request",
        "edit petty_cash_request",
        "show petty_cash_request",
        "delete petty_cash_request",
        "approve petty_cash_request",
        "manage account settings",
        "create deal meeting",
        "edit deal meeting",
        "delete deal meeting",
        "manage crm settings",
        "show support dashboard",
        "show support report",
        "manage support tickets",
        "show support tickets",
        "create support tickets",
        "edit support tickets",
        "delete support tickets",
        "manage support services",
        "create support services",
        "edit support services",
        "show support services",
        "delete support services",
        "manage support supervisor",
        "create support supervisor",
        "edit support supervisor",
        "show support supervisor",
        "delete support supervisor",
        "manage location",
        "create location",
        "edit location",
        "show location",
        "delete location",
        "manage support category",
        "create support category",
        "edit support category",
        "show support category",
        "delete support category",
        "manage support status",
        "create support status",
        "edit support status",
        "show support status",
        "delete support status",
        "manage support priority",
        "create support priority",
        "edit support priority",
        "show support priority",
        "delete support priority",
        "manage support department",
        "create support department",
        "edit support department",
        "show support department",
        "delete support department",
        "manage support settings",
        "show sms balance",
        "manage bulk import export",
        "show holiday",
        "manage employment history",
        "create employment history",
        "edit employment history",
        "show employment history",
        "delete employment history",
        "manage id type",
        "create id type",
        "edit id type",
        "delete id type",
        "manage company debit account",
        "create company debit account",
        "edit company debit account",
        "delete company debit account",
        "manage service",
        "create service",
        "edit service",
        "show service",
        "delete service",
        "manage service subscription",
        "create service subscription",
        "edit service subscription",
        "show service subscription",
        "delete service subscription",
        "manage service history",
        "create service history",
        "edit service history",
        "show service history",
        "delete service history",
        "manage service reminder",
        "create service reminder",
        "edit service reminder",
        "show service reminder",
        "delete service reminder",
        "manage service task",
        "create service task",
        "edit service task",
        "show service task",
        "delete service task",
        "manage billing plan",
        "create billing plan",
        "edit billing plan",
        "show billing plan",
        "delete billing plan",
        "manage subscription status",
        "create subscription status",
        "edit subscription status",
        "show subscription status",
        "delete subscription status",
        "manage service settings",
        "create service settings",
        "edit service settings",
        "show service settings",
        "delete service settings",
        "manage hrm notification setting",
        "manage loan notification setting",
        "manage sales notification setting",
        "manage inventory notification setting",
        "manage logistic notification setting",
        "manage account notification setting",
        "manage jobcard notification setting",
        "manage preclosure",
        "show preclosure",
        "create preclosure",
        "edit preclosure",
        "delete preclosure",
        "manage payment term",
        "show payment term",
        "create payment term",
        "edit payment term",
        "delete payment term",
        "manage payment method",
        "show payment method",
        "create payment method",
        "edit payment method",
        "delete payment method",
        "manage loan disbursement",
        "manage loan",
        "show loan",
        "manage office shift",
        "show office shift",
        "create office shift",
        "edit office shift",
        "delete office shift",
        "manage loan penalty",
        "show loan penalty",
        "create loan penalty",
        "edit loan penalty",
        "delete loan penalty",
        "edit loan active & paid off",
        "delete loan active & paid off",
        "manage loan type",
        "show loan type",
        "create loan type",
        "edit loan type",
        "delete loan type",
        "manage loan payment",
        "show loan payment",
        "create loan payment",
        "edit loan payment",
        "delete loan payment",
        "manage loan status",
        "show loan status",
        "create loan status",
        "edit loan status",
        "delete loan status",
        "manage payment status",
        "show payment status",
        "create payment status",
        "edit payment status",
        "delete payment status",
        "manage loan refund",
        "show loan refund",
        "create loan refund",
        "edit loan refund",
        "delete loan refund",
        "manage loan setting",
        "show loan setting",
        "create loan setting",
        "edit loan setting",
        "manage loan document type",
        "delete loan document type",
        "create loan document type",
        "edit loan document type",
        "manage subsidy report",
        "show subsidy report",
        "manage distributor order status",
        "show distributor order status",
        "create distributor order status",
        "delete distributor order status",
        "edit distributor order status",
        "manage manufacturing",
        "show manufacturing",
        "create manufacturing",
        "delete manufacturing",
        "edit manufacturing",
        "manage manufacturing settings",
        "create manufacturing settings",
        "edit manufacturing settings",
        "delete manufacturing settings",
        "manage manufacturing facility",
        "create manufacturing facility",
        "edit manufacturing facility",
        "delete manufacturing facility",
        "manage workstation type",
        "create workstation type",
        "edit workstation type",
        "delete workstation type",
        "manage plant floor",
        "create plant floor",
        "edit plant floor",
        "delete plant floor",
        "show plant floor",
        "manage work order",
        "create work order",
        "edit work order",
        "delete work order",
        "show work order",
        "manage manufacturing lot",
        "create manufacturing lot",
        "edit manufacturing lot",
        "delete manufacturing lot",
        "manage bill of material",
        "create bill of material",
        "edit bill of material",
        "delete bill of material",
        "show bill of material",
        "manage workstation",
        "create workstation",
        "edit workstation",
        "delete workstation",
        "show workstation",
        "manage operation",
        "create operation",
        "edit operation",
        "delete operation",
        "show operation",
        "manage raw material",
        "show raw material",
        "create raw material",
        "delete raw material",
        "edit raw material",
        "manage geofence",
        "create geofence",
        "edit geofence",
        "show geofence",
        "delete geofence",
        "assign journey supervisor",
        "manage all journeys",
        "manage transport fee report",
        "show transport fee report",
        "show payment report",
        "manage payment report",
        "show pos dashboard",
        "show crm dashboard",
        "show hrm dashboard",
        "copy invoice",
        "show project dashboard",
        "show matter dashboard",
        "show account dashboard",
        "manage user",
        "create user",
        "edit user",
        "delete user",
        "manage role",
        "create role",
        "edit role",
        "delete role",
        "manage permission",
        "create permission",
        "edit permission",
        "delete permission",
        "manage print settings",
        "manage business settings",
        "manage expense",
        "create expense",
        "edit expense",
        "delete expense",
        "manage invoice",
        "create invoice",
        "edit invoice",
        "delete invoice",
        "show invoice",
        "create payment invoice",
        "delete payment invoice",
        "send invoice",
        "delete invoice product",
        "convert invoice",
        "manage constant unit",
        "create constant unit",
        "edit constant unit",
        "delete constant unit",
        "manage constant tax",
        "create constant tax",
        "edit constant tax",
        "delete constant tax",
        "manage constant category",
        "create constant category",
        "edit constant category",
        "delete constant category",
        "manage items",
        "create items",
        "edit items",
        "delete items",
        "manage customer",
        "create customer",
        "edit customer",
        "delete customer",
        "show customer",
        "manage bank account",
        "create bank account",
        "edit bank account",
        "delete bank account",
        "manage bank",
        "create bank",
        "edit bank",
        "delete bank",
        "manage bank transfer",
        "create bank transfer",
        "edit bank transfer",
        "delete bank transfer",
        "manage transaction",
        "manage revenue",
        "create revenue",
        "edit revenue",
        "delete revenue",
        "manage bill",
        "create bill",
        "edit bill",
        "delete bill",
        "show bill",
        "manage payment",
        "create payment",
        "edit payment",
        "delete payment",
        "delete bill product",
        "send bill",
        "create payment bill",
        "delete payment bill",
        "manage order",
        "manage order status change",
        "income report",
        "expense report",
        "income vs expense report",
        "invoice report",
        "bill report",
        "stock report",
        "tax report",
        "loss & profit report",
        "manage credit note",
        "create credit note",
        "edit credit note",
        "delete credit note",
        "manage debit note",
        "create debit note",
        "edit debit note",
        "delete debit note",
        "duplicate invoice",
        "duplicate bill",
        "manage goal",
        "create goal",
        "edit goal",
        "delete goal",
        "manage assets",
        "create assets",
        "edit assets",
        "delete assets",
        "statement report",
        "manage constant custom field",
        "create constant custom field",
        "edit constant custom field",
        "delete constant custom field",
        "manage chart of account",
        "create chart of account",
        "edit chart of account",
        "delete chart of account",
        "manage chart of account type",
        "create chart of account type",
        "edit chart of account type",
        "delete chart of account type",
        "manage chart of account sub type",
        "create chart of account sub type",
        "edit chart of account sub type",
        "delete chart of account sub type",
        "manage journal entry",
        "create journal entry",
        "edit journal entry",
        "delete journal entry",
        "show journal entry",
        "balance sheet report",
        "ledger report",
        "trial balance report",
        "manage client",
        "create client",
        "edit client",
        "delete client",
        "manage lead",
        "create lead",
        "view lead",
        "edit lead",
        "delete lead",
        "move lead",
        "create lead call",
        "edit lead call",
        "delete lead call",
        "create lead email",
        "manage pipeline",
        "create pipeline",
        "edit pipeline",
        "delete pipeline",
        "manage lead stage",
        "create lead stage",
        "edit lead stage",
        "delete lead stage",
        "convert lead to deal",
        "manage source",
        "create source",
        "edit source",
        "delete source",
        "manage label",
        "create label",
        "edit label",
        "delete label",
        "manage deal",
        "create deal",
        "view task",
        "create task",
        "edit task",
        "delete task",
        "edit deal",
        "view deal",
        "delete deal",
        "move deal",
        "create deal call",
        "edit deal call",
        "delete deal call",
        "create deal email",
        "manage stage",
        "create stage",
        "edit stage",
        "delete stage",
        "manage employee",
        "create employee",
        "view employee",
        "edit employee",
        "delete employee",
        "manage employee profile",
        "show employee profile",
        "manage department",
        "create department",
        "view department",
        "edit department",
        "delete department",
        "manage designation",
        "create designation",
        "view designation",
        "edit designation",
        "delete designation",
        "manage branch",
        "create branch",
        "edit branch",
        "delete branch",
        "manage document type",
        "create document type",
        "edit document type",
        "delete document type",
        "manage document",
        "create document",
        "edit document",
        "delete document",
        "manage payslip type",
        "create payslip type",
        "edit payslip type",
        "delete payslip type",
        "create allowance",
        "edit allowance",
        "delete allowance",
        "create commission",
        "edit commission",
        "delete commission",
        "manage allowance option",
        "create allowance option",
        "edit allowance option",
        "delete allowance option",
        "manage loan option",
        "create loan option",
        "edit loan option",
        "delete loan option",
        "manage deduction option",
        "create deduction option",
        "edit deduction option",
        "delete deduction option",
        "create loan",
        "edit loan",
        "delete loan",
        "create other deduction",
        "edit other deduction",
        "delete other deduction",
        "create other payment",
        "edit other payment",
        "delete other payment",
        "create overtime",
        "edit overtime",
        "delete overtime",
        "manage set salary",
        "edit set salary",
        "manage pay slip",
        "create set salary",
        "create pay slip",
        "manage company policy",
        "create company policy",
        "edit company policy",
        "manage appraisal",
        "create appraisal",
        "edit appraisal",
        "show appraisal",
        "delete appraisal",
        "manage goal tracking",
        "create goal tracking",
        "edit goal tracking",
        "delete goal tracking",
        "manage goal type",
        "create goal type",
        "edit goal type",
        "delete goal type",
        "manage indicator",
        "create indicator",
        "edit indicator",
        "show indicator",
        "delete indicator",
        "manage training",
        "create training",
        "edit training",
        "delete training",
        "show training",
        "manage trainer",
        "create trainer",
        "edit trainer",
        "delete trainer",
        "manage training type",
        "create training type",
        "edit training type",
        "delete training type",
        "manage award",
        "create award",
        "edit award",
        "delete award",
        "manage award type",
        "create award type",
        "edit award type",
        "delete award type",
        "manage resignation",
        "create resignation",
        "edit resignation",
        "delete resignation",
        "manage travel",
        "create travel",
        "edit travel",
        "delete travel",
        "manage promotion",
        "create promotion",
        "edit promotion",
        "delete promotion",
        "manage complaint",
        "create complaint",
        "edit complaint",
        "delete complaint",
        "manage warning",
        "create warning",
        "edit warning",
        "delete warning",
        "manage termination",
        "create termination",
        "edit termination",
        "delete termination",
        "manage termination type",
        "create termination type",
        "edit termination type",
        "delete termination type",
        "manage job application",
        "create job application",
        "show job application",
        "delete job application",
        "move job application",
        "add job application skill",
        "add job application note",
        "delete job application note",
        "manage job onBoard",
        "manage job category",
        "create job category",
        "edit job category",
        "delete job category",
        "manage job",
        "create job",
        "edit job",
        "show job",
        "delete job",
        "manage job stage",
        "create job stage",
        "edit job stage",
        "delete job stage",
        "Manage Competencies",
        "Create Competencies",
        "Edit Competencies",
        "Delete Competencies",
        "manage custom question",
        "create custom question",
        "edit custom question",
        "delete custom question",
        "create interview schedule",
        "edit interview schedule",
        "delete interview schedule",
        "show interview schedule",
        "create estimation",
        "view estimation",
        "edit estimation",
        "delete estimation",
        "edit holiday",
        "create holiday",
        "delete holiday",
        "manage holiday",
        "show career",
        "manage meeting",
        "create meeting",
        "edit meeting",
        "delete meeting",
        "manage event",
        "create event",
        "edit event",
        "delete event",
        "manage transfer",
        "create transfer",
        "edit transfer",
        "delete transfer",
        "manage announcement",
        "create announcement",
        "edit announcement",
        "delete announcement",
        "manage leave",
        "create leave",
        "edit leave",
        "delete leave",
        "manage leave type",
        "create leave type",
        "edit leave type",
        "delete leave type",
        "manage attendance",
        "create attendance",
        "edit attendance",
        "delete attendance",
        "manage report",
        "manage project",
        "create project",
        "view project",
        "edit project",
        "delete project",
        "share project",
        "view project expense",
        "view project income",
        "create milestone",
        "edit milestone",
        "delete milestone",
        "view milestone",
        "view grant chart",
        "manage project stage",
        "create project stage",
        "edit project stage",
        "delete project stage",
        "view timesheet",
        "view expense",
        "manage project task",
        "create project task",
        "edit project task",
        "view project task",
        "delete project task",
        "view activity",
        "view CRM activity",
        "manage project task stage",
        "edit project task stage",
        "create project task stage",
        "delete project task stage",
        "manage timesheet",
        "manage matter timesheet",
        "create timesheet",
        "create matter timesheet",
        "edit timesheet",
        "edit matter timesheet",
        "delete timesheet",
        "delete matter timesheet",
        "manage bug report",
        "create bug report",
        "edit bug report",
        "delete bug report",
        "move bug report",
        "manage bug status",
        "create bug status",
        "edit bug status",
        "delete bug status",
        "manage system settings",
        "manage plan",
        "manage company plan",
        "buy plan",
        "manage form builder",
        "create form builder",
        "edit form builder",
        "delete form builder",
        "manage performance type",
        "create performance type",
        "edit performance type",
        "delete performance type",
        "manage form field",
        "create form field",
        "edit form field",
        "delete form field",
        "view form response",
        "create budget plan",
        "edit budget plan",
        "manage budget plan",
        "delete budget plan",
        "view budget plan",
        "manage warehouse",
        "create warehouse",
        "edit warehouse",
        "show warehouse",
        "delete warehouse",
        "manage purchase",
        "create purchase",
        "edit purchase",
        "show purchase",
        "delete purchase",
        "send purchase",
        "create payment purchase",
        "manage pos",
        "manage contract type",
        "create contract type",
        "edit contract type",
        "delete contract type",
        "manage contract",
        "create contract",
        "edit contract",
        "delete contract",
        "show contract",
        "create barcode",
        "create webhook",
        "edit webhook",
        "delete webhook",
        "manage batch",
        "show batch",
        "manage kds screen",
        "show kds screen",
        "kds operator login",
        "kds report defects",
        "kds consume materials",
        "kds view assigned operations",
        "kds supervisor dashboard",
        "kds reassign operations",
        "kds override priority",
        "kds view all workstations",
        "kds manage alerts",
        "kds configure settings",
        "kds manage operators",
        "kds view analytics",
        "manage production plan",
        "create production plan",
        "edit production plan",
        "delete production plan",
        "show production plan",
        "show production report",
        "manage picking slips",
        "create picking slips",
        "edit picking slips",
        "show picking slips",
        "delete picking slips",
        "manage sprint",
        "create sprint",
        "edit sprint",
        "view sprint",
        "delete sprint",
        "manage late",
        "show late",
        "create late",
        "edit late",
        "delete late",
        "manage purchase notification setting",
        "manage subtask",
        "create subtask",
        "view subtask",
        "edit subtask",
        "delete subtask",
        "manage bonus type",
        "create bonus type",
        "edit bonus type",
        "delete bonus type"
    ]
}