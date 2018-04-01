<?php echo $header; ?><?php echo $column_left; ?>

<div id="content">
  <div class="page-header">
    <div class="container-fluid">
      <div class="pull-right">
        <button type="button" @click="submit" form="form-weight1" data-toggle="tooltip" title="<?php echo $button_save; ?>" class="btn btn-primary"><i class="fa fa-save"></i></button>
        <a href="<?php echo $cancel; ?>" data-toggle="tooltip" title="<?php echo $button_cancel; ?>" class="btn btn-default"><i class="fa fa-reply"></i></a></div>
      <h1><?php echo $heading_title; ?></h1>
      <ul class="breadcrumb">
        <?php foreach ($breadcrumbs as $breadcrumb) { ?>
        <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
        <?php } ?>
      </ul>
    </div>
  </div>
  <div class="container-fluid">
    <?php if ($error_warning) { ?>
    <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?>
      <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <?php } ?>
    <div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title"><i class="fa fa-pencil"></i> <?php echo $text_edit; ?></h3>
      </div>
      <div class="panel-body">
        <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form-weight1" class="form-horizontal">
          <div class="row">
            <div class="col-sm-2">
              <ul class="nav nav-pills nav-stacked">
                <li class="active"><a href="#tab-general" data-toggle="tab"><?php echo $tab_general; ?></a></li>
               
                <li v-for="exp in weightExpress" >
                  <a @click="switchExp(exp)" :href="'#tab-geo-zone' + exp.id" v-show="editid !== exp.id" data-toggle="tab" v-text="exp.name"></a>
                  <input type="text" v-show="editid === exp.id" v-model="exp.name">
                  <i class="fa fa-pencil" v-show="!editting" @click="editid = exp.id"></i>
                  <button type="button" class="btn btn-primary" v-show="editid === exp.id" @click="editid = ''">ok</button>
                  <button type="button" class="btn btn-danger" v-show="editid === exp.id" @click="delExp(exp)">del</button>
                </li>

                <li v-show="creating">
                  <input type="text" v-model="newExpName" class="form-control"> 
                  <button type="button" class="btn btn-primary" @click="doCreate" :disabled="disabled">ok</button>
                  <button type="button" class="btn btn-danger" @click="creating = false">cancel</button>
                </li>

                <li>
                <button type="button" class="btn btn-danger" @click="applyNewExp">
                <i class="glyphicon glyphicon-plus"></i>
                </button></li>
              </ul>
            </div>
            <div class="col-sm-10">
              <div class="tab-content">
                <div class="tab-pane active" id="tab-general">
                  <div class="form-group">
                    <label class="col-sm-2 control-label" for="input-tax-class"><?php echo $entry_tax_class; ?></label>
                    <div class="col-sm-10">
                      <select name="weight_tax_class_id" id="input-tax-class" v-model="weight_tax_class_id" class="form-control">
                        <option value="0"><?php echo $text_none; ?></option>
                        <?php foreach ($tax_classes as $tax_class) { ?>
                        <?php if ($tax_class['tax_class_id'] == $weight_tax_class_id) { ?>
                        <option value="<?php echo $tax_class['tax_class_id']; ?>" selected="selected"><?php echo $tax_class['title']; ?></option>
                        <?php } else { ?>
                        <option value="<?php echo $tax_class['tax_class_id']; ?>"><?php echo $tax_class['title']; ?></option>
                        <?php } ?>
                        <?php } ?>
                      </select>
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-2 control-label" for="input-status"><?php echo $entry_status; ?></label>
                    <div class="col-sm-10">
                      <select name="weight_status" v-model="weight_status" id="input-status" class="form-control">
                        <?php if ($weight_status) { ?>
                        <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                        <option value="0"><?php echo $text_disabled; ?></option>
                        <?php } else { ?>
                        <option value="1"><?php echo $text_enabled; ?></option>
                        <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                        <?php } ?>
                      </select>
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-2 control-label" for="input-sort-order"><?php echo $entry_sort_order; ?></label>
                    <div class="col-sm-10">
                      <input type="text" name="weight_sort_order" v-model="weight_sort_order" placeholder="<?php echo $entry_sort_order; ?>" id="input-sort-order" class="form-control" />
                    </div>
                  </div>
                </div>

                <div class="tab-pane" v-for="exp in weightExpress" :id="'tab-geo-zone' + exp.id">
                  <div class="form-group">
                    <label class="col-sm-2 control-label" :for="'input-rate'  + exp.id"><span data-toggle="tooltip" title="<?php echo $help_rate; ?>"><?php echo $entry_rate; ?></span></label>
                    <div class="col-sm-10">
                      <textarea rows="5" placeholder="<?php echo $entry_rate; ?>" class="form-control" v-model="exp.rate"></textarea>
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="col-sm-2 control-label" ><?php echo $entry_status; ?></label>
                    <div class="col-sm-10">
                      <select class="form-control" v-model="exp.status">
                        <option value="1"><?php echo $text_enabled; ?></option>
                        <option value="0"><?php echo $text_disabled; ?></option>
                      </select>
                    </div>
                  </div>

                  <div class="form-group">
                    <label class="col-sm-2 control-label"><?php echo $entry_geo_zones; ?></label>
                    <div class="col-sm-10">
                      <div class="col-sm-10">
                        <label class="control-label">
                          <input type="checkbox" name="weight_id_geozone" :checked="exp.zones.toString() === allZones.toString()"  @change="checkAll">
                          all
                        </label>
                        <label>
                            <!-- <input type="text" v-model="searchValue" > -->
                            /count <i v-text="exp.zones.length"></i>
                        </label>
                      </div>
                      <div class="col-sm-10">
                        <label v-for="geoZone in geoZones" style="margin-right: 15px;">
                          <input type="checkbox" name="weight_id_geozone" :value="geoZone.geo_zone_id" v-model="exp.zones"><span v-text="geoZone.name"></span>
                        </label>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/vue"></script>
<script>
(function(window) {
  var config = {
    data: {
      geoZones: <?php echo json_encode($geo_zones, 1); ?>,
      weightExpress: <?php echo json_encode($weight1_express, 1); ?>,
    }
  };
  config.data.geoZones = config.data.geoZones.sort(function (a, b) {
    return a.name > b.name ? 1 : -1;
  });
  console.log(config);
  var createNewExp = function (name) {
    return {
      id: +new Date(),
      name: name,
      zones: [],
      rate: '',
      status: 0,
    }
  };

  var allZones = config.data.geoZones.map(i => i.geo_zone_id);
  var data = Object.assign({
    newExpName: '',
    creating: false,
    searchValue: '',
    currentExp: null,
    editid: '',
    editting: false,
    weight_sort_order: '<?php echo $weight1_sort_order; ?>',
    weight_status: '<?php echo $weight1_status; ?>',
    weight_tax_class_id: '<?php echo $weight1_tax_class_id; ?>',
    allZones: allZones,
  }, config.data);
  var vm = new Vue({
    data: data,
    computed: {
      disabled() {
        return !this.newExpName;
      }
    },
    watch: {
      
    },
    methods: {
      applyNewExp () {
        this.creating = true;
      },

      checkAll (v) {
        var value = v.target.checked;
        if (value) {
          this.$set(this.currentExp, 'zones', allZones);
        } else {
          this.$set(this.currentExp, 'zones', []);
        }
      },

      doCreate () {
        if (!this.newExpName) {
          return;
        }
        var newExp = createNewExp(this.newExpName);
        this.weightExpress.push(newExp);
        this.creating = false;
        this.newExpName = '';
      },
      
      save (exp) {

      },

      delExp (exp) {
        var index = this.weightExpress.indexOf(exp);
        if (index === -1) {
          return;
        }
        this.weightExpress.splice(index, 1);
        this.editid = '';
      },

      switchExp (exp) {
        this.currentExp = exp;
      },

      submit () {
        var submitData = {
          weight1_sort_order: this.weight_sort_order,
          weight1_status: this.weight_status,
          weight1_tax_class_id: this.weight_tax_class_id,
          weight1_express: this.weightExpress
        };
        submitData = JSON.stringify(submitData);
        $.ajax({
          type: 'post',
          headers: {
            'Content-Type': 'application/json'
          },
          data: submitData,
          dataType: 'json',
          success: function(res) {
            if (res.success !== 0) {
              return;
            }
            content.querySelector('a[data-toggle="tooltip"]').click();
            console.log(res);
          }
        });
      }
    }
  });

  vm.$mount(content);
})(window);
  
</script>
<?php echo $footer; ?> 