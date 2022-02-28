//*************************************************************************
// hybrid
//*************************************************************************

namespace gtsam {

// #include <gtsam/inference/Key.h>
// class gtsam::KeyVector;

#include <gtsam/hybrid/DCFactor.h>
#include <gtsam/slam/BetweenFactor.h>

virtual class DCFactor {};

#include <gtsam/hybrid/DCMixtureFactor.h>
template <T>
virtual class DCMixtureFactor : gtsam::DCFactor {
  DCMixtureFactor();
  DCMixtureFactor(const gtsam::KeyVector& keys,
                  const gtsam::DiscreteKeys& discreteKeys,
                  const std::vector<T*>& factors, bool normalized = false);
};

typedef gtsam::DCMixtureFactor<gtsam::BetweenFactor<double>>
    DCMixtureFactorBetweenFactorDouble;

#include <gtsam/hybrid/DCGaussianMixtureFactor.h>

virtual class DCGaussianMixtureFactor : gtsam::DCFactor {
  DCGaussianMixtureFactor();
  DCGaussianMixtureFactor(
      const gtsam::KeyVector& continuousKeys,
      const gtsam::DiscreteKeys& discreteKeys,
      const gtsam::DCGaussianMixtureFactor::Factors& factors);
};

#include <gtsam/hybrid/GaussianMixture.h>

virtual class GaussianMixture : gtsam::DCGaussianMixtureFactor {
  GaussianMixture();
  GaussianMixture(size_t nrFrontals, const gtsam::KeyVector& continuousKeys,
                  const gtsam::DiscreteKeys& discreteKeys,
                  const gtsam::GaussianMixture::Conditionals& conditionals);
};

#include <gtsam/hybrid/DCFactorGraph.h>

class DCFactorGraph {
  DCFactorGraph();
  gtsam::DiscreteKeys discreteKeys() const;

  size_t size() const;
  bool empty() const;
  void remove(size_t i);
  void resize(size_t size);
  size_t nrFactors() const;

  void print(const std::string& str = "DCFactorGraph",
             const gtsam::KeyFormatter& keyFormatter =
                 gtsam::DefaultKeyFormatter) const;
};

#include <gtsam/hybrid/HybridFactorGraph.h>

template <FG>
virtual class HybridFactorGraph {
  HybridFactorGraph();
  HybridFactorGraph(const FG& factorGraph,
                    const gtsam::DiscreteFactorGraph& discreteGraph,
                    const gtsam::DCFactorGraph& dcGraph);

  bool equals(const gtsam::HybridFactorGraph<FG>& other,
              double tol = 1e-9) const;
  void print(const std::string& str = "HybridFactorGraph",
             const gtsam::KeyFormatter& keyFormatter =
                 gtsam::DefaultKeyFormatter) const;

  const gtsam::DiscreteFactorGraph& discreteGraph() const;
  const gtsam::DCFactorGraph& dcGraph() const;

  gtsam::DiscreteKeys discreteKeys() const;
};

typedef gtsam::HybridFactorGraph<gtsam::NonlinearFactorGraph>
    HybridFactorGraphNonlinear;

#include <gtsam/hybrid/NonlinearHybridFactorGraph.h>

class NonlinearHybridFactorGraph {
  NonlinearHybridFactorGraph();
  NonlinearHybridFactorGraph(const gtsam::NonlinearFactorGraph& nonlinearGraph,
                             const gtsam::DiscreteFactorGraph& discreteGraph,
                             const gtsam::DCFactorGraph& dcGraph);

  const gtsam::NonlinearFactorGraph& nonlinearGraph() const;

  //TODO(Varun) issues with templated inheritance
  const gtsam::DiscreteFactorGraph& discreteGraph() const;
  const gtsam::DCFactorGraph& dcGraph() const;
  gtsam::DiscreteKeys discreteKeys() const;

  gtsam::GaussianHybridFactorGraph linearize(
      const gtsam::Values& continuousValues) const;

  size_t size() const;
  bool empty() const;
  void remove(size_t i);
  void resize(size_t size);
  size_t nrFactors() const;
  gtsam::NonlinearFactor* at(size_t idx) const;

  bool equals(const gtsam::NonlinearHybridFactorGraph& other,
              double tol = 1e-9) const;
  void print(const std::string& str = "NonlinearHybridFactorGraph",
             const gtsam::KeyFormatter& keyFormatter =
                 gtsam::DefaultKeyFormatter) const;
};

#include <gtsam/hybrid/GaussianHybridFactorGraph.h>

class GaussianHybridFactorGraph {
  GaussianHybridFactorGraph();
  GaussianHybridFactorGraph(const gtsam::GaussianFactorGraph& gaussianGraph,
                            const gtsam::DiscreteFactorGraph& discreteGraph,
                            const gtsam::DCFactorGraph& dcGraph);

  size_t size() const;
  void print(const std::string& str = "GaussianHybridFactorGraph",
             const gtsam::KeyFormatter& keyFormatter =
                 gtsam::DefaultKeyFormatter) const;

  //TODO(Varun) issues with templated inheritance
  const gtsam::DiscreteFactorGraph& discreteGraph() const;
  const gtsam::DCFactorGraph& dcGraph() const;
  gtsam::DiscreteKeys discreteKeys() const;

};

#include <gtsam/hybrid/IncrementalHybrid.h>

class IncrementalHybrid {
  IncrementalHybrid();

  void update(gtsam::GaussianHybridFactorGraph graph,
              const gtsam::Ordering& ordering,
              boost::optional<size_t> maxNrLeaves = nullptr);

  GaussianMixture* gaussianMixture(size_t index) const;
  const DiscreteFactorGraph& remainingDiscreteGraph() const;
  const HybridBayesNet& hybridBayesNet() const;
  const GaussianHybridFactorGraph& remainingFactorGraph() const;
};

}  // namespace gtsam