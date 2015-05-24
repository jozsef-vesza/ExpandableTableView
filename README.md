# ExpandableTableView
Example code for creating expandable table view cells using Auto Layout.

## Current status:

![Current status][4]

## Solution

After a significant amount of research, I think I've found the solution with the help of [this great article.][1]

Here are the steps needed to make the cell resize:

Within the Main, and Detail Views, I have originally set the labels to be horizontally and vertically centered. This isn't enough for self sizing cells. The first thing I needed is to set up my layout using vertical spacing constraints instead of simple alignment:

![Main View][2]

Additionally you should set the Main Container's vertical compression resistance to 1000.

The detail view is a bit more tricky: Apart from creating the appropriate vertical constraints, you also have to play with their priorities to reach the desired effect:

* The Detail Container's Height is constrained to be 44 points, but to make it optional, set its priority to 999 (according to the docs, anything lower than "Required", will be regarded such).
* Within the Detail Container, set up the vertical spacing constraints, and give them a priority of 998.

![Detail View][3]

The main idea is the following:

* By default, the cell is collapsed. To achieve this, we must programmatically set the constant of the Detail Container's height constraint to 0. Since its priority is higher than the vertical constraints within the cell's content view, the latter will be ignored, so the Detail Container will be hidden.
* When we select the cell, we want it to expand. This means, that the vertical constraints must take control: we set the priority Detail Container's height constraint to something low (I used 250), so it will be ignored in favor of the constraints within the content view.

I had to modify my `UITableViewCell` subclass to support these operations:

    // `showDetails` is exposed to control, whether the cell should be expanded
    var showsDetails = false {
        didSet {
            detailViewHeightConstraint.priority = showsDetails ? lowLayoutPriority : highLayoutPriority
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailViewHeightConstraint.constant = 0
    }

To trigger the behavior, we must override `tableView(_:didSelectRowAtIndexPath:)`:

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        switch expandedIndexPath {
        case .Some(_) where expandedIndexPath == indexPath:
            expandedIndexPath = nil
        case .Some(let expandedIndex) where expandedIndex != indexPath:
            expandedIndexPath = nil
            self.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        default:
            expandedIndexPath = indexPath
        }
    }

Notice that I've introduced `expandedIndexPath` to keep track of our currently expanded index:

    var expandedIndexPath: NSIndexPath? {
        didSet {
            switch expandedIndexPath {
            case .Some(let index):
                tableView.reloadRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Automatic)
            case .None:
                tableView.reloadRowsAtIndexPaths([oldValue!], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }

Setting the property will result in the table view reloading the appropriate indexes, giving us a perfect opportunity to tell the cell, if it should expand:

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ExpandableTableViewCell
        
        cell.mainTitle = viewModel.mainTitleForRow(indexPath.row)
        cell.detailTitle = viewModel.detailTitleForRow(indexPath.row)
        
        switch expandedIndexPath {
        case .Some(let expandedIndexPath) where expandedIndexPath == indexPath:
            cell.showsDetails = true
        default:
            cell.showsDetails = false
        }
        
        return cell
    }

The last step is to enable self-sizing in `viewDidLoad()`:

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset.top = statusbarHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 125
    }

### Result

![Result][4]

Cells now correctly size themselves. You may notice that the animation is still a bit weird, but fixing that does not fall into the scope of this question.

### Conclusion

This was way harder than it should be. 😀 I really hope to see some improvements in the future.

  [1]: http://pivotallabs.com/expandable-uitableviewcells/
  [2]: http://i.stack.imgur.com/LdlQK.png
  [3]: http://i.stack.imgur.com/gHkA6.png
  [4]: http://i.stack.imgur.com/tdBLK.gif

## Misc

Originally asked on [Stack Overflow](http://stackoverflow.com/questions/30078267/dynamically-size-table-view-cells-using-auto-layout-constraints).
