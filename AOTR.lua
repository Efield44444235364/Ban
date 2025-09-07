print("‼️ Beta Testing maybe u got bug or Ban!!")

game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer()
game:GetService("RobloxReplicatedStorage").UpdatePlayerBlockList:FireServer()
game:GetService("RobloxReplicatedStorage").SendPlayerBlockList:FireServer()
game:GetService("RobloxReplicatedStorage").NewPlayerCanManageDetails:FireServer()
game:GetService("ReplicatedStorage").Assets.Remotes.GET:InvokeServer()
game:GetService("ReplicatedStorage").Assets.Remotes.POST:FireServer()
game:GetService("RobloxReplicatedStorage").GetServerVersion:InvokeServer()
