# ID 10087: Find all posts which were reacted to with a heart

SELECT DISTINCT fp.* 
FROM facebook_reactions AS fr 
INNER JOIN facebook_posts AS fp
    ON fr.post_id = fp.post_id
WHERE reaction = 'heart'
