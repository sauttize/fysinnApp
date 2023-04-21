extends TabContainer

func changeTab (tab_num : int):
	set_current_tab(tab_num)


# Tab changes
func _on_btn_base_button_up():
	changeTab(0)
func _on_btn_conocimientos_button_up():
	changeTab(1)
