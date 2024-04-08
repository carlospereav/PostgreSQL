select followers.*, leader.name as leader, follower.name as follower from followers
inner join users leader on leader.id = followers.leader_id
inner join users follower on follower.id = followers.follower_id