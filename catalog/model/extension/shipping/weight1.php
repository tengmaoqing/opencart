<?php
class ModelExtensionShippingWeight1 extends Model {
	public function getQuote($address) {
		$this->load->language('extension/shipping/weight1');

		$quote_data = array();

		$express = $this->config->get('weight1_express');

		foreach ($express as $exp) {
			if ($exp['status']) {
				$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "zone_to_geo_zone WHERE geo_zone_id in (" . implode(',', $exp['zones']) . ") AND country_id = '" . (int)$address['country_id'] . "' AND (zone_id = '" . (int)$address['zone_id'] . "' OR zone_id = '0')");

				if ($query->num_rows) {
					$status = true;
				} else {
					$status = false;
				}
			} else {
				$status = false;
			}

			if ($status) {
				$cost = '';
				$weight = $this->cart->getWeight();

				$rates = explode(',', $exp['rate']);

				foreach ($rates as $rate) {
					$data = explode(':', $rate);

					if ($data[0] >= $weight) {
						if (isset($data[1])) {
							$cost = $data[1];
						}

						break;
					}
				}
				
				if ((string)$cost != '') {
					$quote_data['express_' . $exp['id']] = array(
						'code'         => 'weight1.express_' .$exp['id'],
						'title'        => $exp['name'] . '  (' . $this->language->get('text_weight') . ' ' . $this->weight->format($weight, $this->config->get('config_weight_class_id')) . ')',
						'cost'         => $cost,
						'tax_class_id' => $this->config->get('weight1_tax_class_id'),
						'text'         => $this->currency->format($this->tax->calculate($cost, $this->config->get('weight1_tax_class_id'), $this->config->get('config_tax')), $this->session->data['currency'])
					);
				}
			}
		}

		// foreach ($query->rows as $result) {
		// 	if ($this->config->get('weight_' . $result['geo_zone_id'] . '_status')) {
		// 		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "zone_to_geo_zone WHERE geo_zone_id = '" . (int)$result['geo_zone_id'] . "' AND country_id = '" . (int)$address['country_id'] . "' AND (zone_id = '" . (int)$address['zone_id'] . "' OR zone_id = '0')");

		// 		if ($query->num_rows) {
		// 			$status = true;
		// 		} else {
		// 			$status = false;
		// 		}
		// 	} else {
		// 		$status = false;
		// 	}

		// 	if ($status) {
		// 		$cost = '';
		// 		$weight = $this->cart->getWeight();

		// 		$rates = explode(',', $this->config->get('weight_' . $result['geo_zone_id'] . '_rate'));

		// 		foreach ($rates as $rate) {
		// 			$data = explode(':', $rate);

		// 			if ($data[0] >= $weight) {
		// 				if (isset($data[1])) {
		// 					$cost = $data[1];
		// 				}

		// 				break;
		// 			}
		// 		}

		// 		if ((string)$cost != '') {
		// 			$quote_data['weight_' . $result['geo_zone_id']] = array(
		// 				'code'         => 'weight.weight_' . $result['geo_zone_id'],
		// 				'title'        => $result['name'] . '  (' . $this->language->get('text_weight') . ' ' . $this->weight->format($weight, $this->config->get('config_weight_class_id')) . ')',
		// 				'cost'         => $cost,
		// 				'tax_class_id' => $this->config->get('weight_tax_class_id'),
		// 				'text'         => $this->currency->format($this->tax->calculate($cost, $this->config->get('weight_tax_class_id'), $this->config->get('config_tax')), $this->session->data['currency'])
		// 			);
		// 		}
		// 	}
		// }

		$method_data = array();

		if ($quote_data) {
			$method_data = array(
				'code'       => 'weight1',
				'title'      => $this->language->get('text_title'),
				'quote'      => $quote_data,
				'sort_order' => $this->config->get('weight1_sort_order'),
				'error'      => false
			);
		}

		return $method_data;
	}
}