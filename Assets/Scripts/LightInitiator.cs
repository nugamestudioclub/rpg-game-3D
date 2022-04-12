using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightInitiator : MonoBehaviour
{
    [SerializeField]
    private Light[] lights;
    
    private Ray ray;
    private RaycastHit hit;

    private TargetStoneComponent[] components;
    private Dictionary<TargetStoneComponent, bool> calledComponents = new Dictionary<TargetStoneComponent, bool>();

    // Start is called before the first frame update
    void Start()
    {
        ray = new Ray();
        components = (TargetStoneComponent[])GameObject.FindObjectsOfType(typeof(TargetStoneComponent));
        foreach(TargetStoneComponent component in components)
        {
            calledComponents.Add(component, false);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    private void FixedUpdate()
    {
        for(int i =0; i < lights.Length; i++)
        {
            ray.origin = lights[i].transform.position;
            ray.direction = lights[i].transform.forward;
            if(Physics.Raycast(ray,out hit))
            {
                TargetStoneComponent component;
                if((component=hit.transform.gameObject.GetComponent<TargetStoneComponent>())!=null||
                    (component= hit.transform.gameObject.GetComponentInChildren<TargetStoneComponent>())!=null)
                {
                    if (!component.IsCalled)
                    {
                        component.Call();
                        calledComponents[component] = true;
                    }
                    
                }
            }

        }
        foreach(TargetStoneComponent component in this.calledComponents.Keys)
        {
            if (this.calledComponents[component])
            {
                
            }
            else
            {
                component.UnCall();
            }
        }
    }
}
