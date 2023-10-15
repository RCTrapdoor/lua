function findMin(branch, newNode, shortestNode)
	shortestNode = shortestNode or branch
	for i = 1, #branch.nodes do
		if vecDist(vecSub(branch.nodes[i], newNode)) < vecDist(vecSub(shortestNode, newNode)) then
			shortestNode = branch.nodes[i]
		end
		shortestNode = findMin(branch.nodes[i], newNode, shortestNode)
	end
	return shortestNode
end