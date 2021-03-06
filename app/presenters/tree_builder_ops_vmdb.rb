class TreeBuilderOpsVmdb < TreeBuilder
  has_kids_for VmdbTableEvm, %i[x_get_tree_vmdb_table_kids]

  private

  def tree_init_options
    {:lazy => true}
  end

  def root_options
    {
      :text    => t = _("VMDB"),
      :tooltip => t,
      :icon    => 'fa fa-database'
    }
  end

  # Get root nodes count/array for explorer tree
  def x_get_tree_roots
    objects = Rbac.filtered(VmdbDatabase.my_database.try(:evm_tables).to_a).to_a
    count_only_or_objects(false, objects, "name")
  end

  # Handle custom tree nodes (object is a Hash)
  def x_get_tree_custom_kids(object, count_only)
    vmdb_table_id = object[:id].split("|").last.split('-').last
    vmdb_indexes  = VmdbIndex.includes(:vmdb_table).where(:vmdb_tables => {:type => 'VmdbTableEvm', :id => vmdb_table_id})
    count_only_or_objects(count_only, vmdb_indexes, "name")
  end

  def x_get_tree_vmdb_table_kids(object, count_only)
    return 1 if count_only # each table has one indexes subdir

    [
      {
        :id       => object.id.to_s,
        :text     => _("Indexes"),
        :icon     => "pficon pficon-folder-close",
        :tip      => _("Indexes"),
        :expanded => true # load this node expanded with its children
      }
    ]
  end
end
