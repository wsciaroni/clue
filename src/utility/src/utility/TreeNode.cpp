#include "utility/TreeNode.h"

namespace Clue::Utility
{
    TreeNode::TreeNode(std::vector<std::shared_ptr<TreeNode>> childrenIn) : children{childrenIn}, parent{nullptr}, isRoot{true}
    {
    }

    TreeNode::TreeNode(std::shared_ptr<TreeNode> parentIn, std::vector<std::shared_ptr<TreeNode>> childrenIn) : children{childrenIn}, parent{parentIn}, isRoot{false}
    {
    }
    TreeNode::~TreeNode()
    {
    }

    const bool TreeNode::isRootNode()
    {
        return isRoot;
    }
} // namespace Clue::Utility
