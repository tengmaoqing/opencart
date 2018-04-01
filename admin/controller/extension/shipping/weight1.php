<?php
class ControllerExtensionShippingWeight1 extends Controller {
  private $error = array();

  public function index() {
    $this->load->language('extension/shipping/weight1');
    $this->document->setTitle($this->language->get('heading_title'));

    $this->load->model('setting/setting');
    
    if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
      
      $postData = file_get_contents('php://input');
      $postData = json_decode($postData, 1);
      $this->model_setting_setting->editSetting('weight1', $postData);

      $this->session->data['success'] = $this->language->get('text_success');

      echo json_encode(array(
        'success' => 0,
        'message' => $this->language->get('text_success')
      ));
      return;
      // $this->response->redirect($this->url->link('extension/extension', 'token=' . $this->session->data['token'] . '&type=shipping', true));
    }

    $data['heading_title'] = $this->language->get('heading_title');
    
    $data['text_edit'] = $this->language->get('text_edit');
    $data['text_none'] = $this->language->get('text_none');
    $data['text_enabled'] = $this->language->get('text_enabled');
    $data['text_disabled'] = $this->language->get('text_disabled');

    $data['entry_rate'] = $this->language->get('entry_rate');
    $data['entry_tax_class'] = $this->language->get('entry_tax_class');
    $data['entry_status'] = $this->language->get('entry_status');
    $data['entry_sort_order'] = $this->language->get('entry_sort_order');
    $data['entry_geo_zones'] = $this->language->get('entry_geo_zones');

    $data['help_rate'] = $this->language->get('help_rate');

    $data['button_save'] = $this->language->get('button_save');
    $data['button_cancel'] = $this->language->get('button_cancel');

    $data['tab_general'] = $this->language->get('tab_general');

    if (isset($this->error['warning'])) {
      $data['error_warning'] = $this->error['warning'];
    } else {
      $data['error_warning'] = '';
    }

    $data['breadcrumbs'] = array();

    $data['breadcrumbs'][] = array(
      'text' => $this->language->get('text_home'),
      'href' => $this->url->link('common/dashboard', 'token=' . $this->session->data['token'], true)
    );

    $data['breadcrumbs'][] = array(
      'text' => $this->language->get('text_extension'),
      'href' => $this->url->link('extension/extension', 'token=' . $this->session->data['token'] . '&type=shipping', true)
    );

    $data['breadcrumbs'][] = array(
      'text' => $this->language->get('heading_title'),
      'href' => $this->url->link('extension/shipping/weight1', 'token=' . $this->session->data['token'], true)
    );

    $data['action'] = $this->url->link('extension/shipping/weight1', 'token=' . $this->session->data['token'], true);

    $data['cancel'] = $this->url->link('extension/extension', 'token=' . $this->session->data['token'] . '&type=shipping', true);

    $this->load->model('localisation/geo_zone');

    $geo_zones = $this->model_localisation_geo_zone->getGeoZones();

    // foreach ($geo_zones as $geo_zone) {
    //   if (isset($this->request->post['weight_' . $geo_zone['geo_zone_id'] . '_rate'])) {
    //     $data['weight_' . $geo_zone['geo_zone_id'] . '_rate'] = $this->request->post['weight_' . $geo_zone['geo_zone_id'] . '_rate'];
    //   } else {
    //     $data['weight_' . $geo_zone['geo_zone_id'] . '_rate'] = $this->config->get('weight_' . $geo_zone['geo_zone_id'] . '_rate');
    //   }

    //   if (isset($this->request->post['weight_' . $geo_zone['geo_zone_id'] . '_status'])) {
    //     $data['weight_' . $geo_zone['geo_zone_id'] . '_status'] = $this->request->post['weight_' . $geo_zone['geo_zone_id'] . '_status'];
    //   } else {
    //     $data['weight_' . $geo_zone['geo_zone_id'] . '_status'] = $this->config->get('weight_' . $geo_zone['geo_zone_id'] . '_status');
    //   }
    // }

    $data['geo_zones'] = $geo_zones;

    if (isset($this->request->post['weight1_tax_class_id'])) {
      $data['weight1_tax_class_id'] = $this->request->post['weight1_tax_class_id'];
    } else {
      $data['weight1_tax_class_id'] = $this->config->get('weight1_tax_class_id');
    }

    $this->load->model('localisation/tax_class');

    $data['tax_classes'] = $this->model_localisation_tax_class->getTaxClasses();

    if (isset($this->request->post['weight1_status'])) {
      $data['weight1_status'] = $this->request->post['weight1_status'];
    } else {
      $data['weight1_status'] = $this->config->get('weight1_status');
    }

    if (isset($this->request->post['weight1_sort_order'])) {
      $data['weight1_sort_order'] = $this->request->post['weight1_sort_order'];
    } else {
      $data['weight1_sort_order'] = $this->config->get('weight1_sort_order');
    }
    // 快递公司
    $data['weight1_express'] = $this->config->get('weight1_express') ? $this->config->get('weight1_express') : array();
    $data['header'] = $this->load->controller('common/header');
    $data['column_left'] = $this->load->controller('common/column_left');
    $data['footer'] = $this->load->controller('common/footer');

    $this->response->setOutput($this->load->view('extension/shipping/weight1', $data));
  }

  protected function validate() {
    if (!$this->user->hasPermission('modify', 'extension/shipping/weight')) {
      $this->error['warning'] = $this->language->get('error_permission');
    }

    return !$this->error;
  }
}