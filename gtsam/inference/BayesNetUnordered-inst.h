/* ----------------------------------------------------------------------------

* GTSAM Copyright 2010, Georgia Tech Research Corporation,
* Atlanta, Georgia 30332-0415
* All Rights Reserved
* Authors: Frank Dellaert, et al. (see THANKS for the full author list)

* See LICENSE for the license information

* -------------------------------------------------------------------------- */

/**
* @file    BayesNet.h
* @brief   Bayes network
* @author  Frank Dellaert
* @author  Richard Roberts
*/

#pragma once

#include <gtsam/inference/BayesNetUnordered.h>
#include <gtsam/inference/FactorGraphUnordered-inst.h>

namespace gtsam {

  /* ************************************************************************* */
  template<class CONDITIONAL>
  void BayesNetUnordered<CONDITIONAL>::print(const std::string& s, const KeyFormatter& formatter) const
  {
    Base::print(s, formatter);
  }

  /* ************************************************************************* */
  template<class CONDITIONAL>
  void BayesNetUnordered<CONDITIONAL>::saveGraph(
    const std::string &s, const KeyFormatter& keyFormatter = DefaultKeyFormatter)
  {
    std::ofstream of(s.c_str());
    of << "digraph G{\n";

    BOOST_REVERSE_FOREACH(const sharedConditional& conditional, *this) {
      typename CONDITIONAL::Frontals frontals = conditional->frontals();
      Index me = frontals.front();
      typename CONDITIONAL::Parents parents = conditional->parents();
      BOOST_FOREACH(Index p, parents)
        of << p << "->" << me << std::endl;
    }

    of << "}";
    of.close();
  }

}
