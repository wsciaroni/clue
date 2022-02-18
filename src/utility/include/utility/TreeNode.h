#include <vector>
#include <memory>

namespace Clue::Utility
{
    class TreeNode
    {
    private:
        std::vector<std::shared_ptr<TreeNode>> children;
        std::shared_ptr<TreeNode> parent = nullptr;
        const bool isRoot = false;

    public:
        TreeNode(std::vector<std::shared_ptr<TreeNode>> children);
        TreeNode(std::shared_ptr<TreeNode> parent, std::vector<std::shared_ptr<TreeNode>> children);
        ~TreeNode();

        const bool isRootNode();
    };

} // namespace Clue::Utility
