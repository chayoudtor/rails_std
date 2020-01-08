module ApplicationHelper
    def sortable(column, title = nil)
        title ||= column.titleize
        direction = column == sort_column && sort_direction == "asc" ? "desc" : "acs"
        link_to title, {:sort => column, :direction => direction}
    end
end
